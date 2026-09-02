package kopo.poly.controller.api;

import jakarta.servlet.http.HttpSession;
import kopo.poly.dto.request.JoinSiteRequestDTO;
import kopo.poly.dto.request.SiteCreateRequestDTO;
import kopo.poly.dto.request.SiteDetailRequestDTO;
import kopo.poly.dto.response.ConnectedSubcontractorResponseDTO;
import kopo.poly.dto.response.SiteConnectionResponseDTO;
import kopo.poly.dto.response.SiteOwnerResponseDTO;
import kopo.poly.dto.response.SiteResponseDTO;
import kopo.poly.entity.Site;
import kopo.poly.entity.User;
import kopo.poly.entity.enums.UserRole;
import kopo.poly.repository.UserRepository;
import kopo.poly.service.ISiteService;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Map;

@RestController
public class SiteApiController {

    private final ISiteService siteService;
    private final UserRepository userRepository;

    public SiteApiController(ISiteService siteService, UserRepository userRepository) {
        this.siteService = siteService;
        this.userRepository = userRepository;
    }

    @GetMapping("/api/sites")
    public List<SiteResponseDTO> list(HttpSession session) {
        return siteService.list(requireLoginUserId(session));
    }

    @PostMapping("/api/sites")
    @ResponseStatus(HttpStatus.CREATED)
    public SiteResponseDTO create(@RequestBody SiteCreateRequestDTO request, HttpSession session) {
        Long loginUserId = requireLoginUserId(session);
        Site site = siteService.create(request, loginUserId);
        return SiteResponseDTO.from(site, null);
    }

    // 원청이 "건설사 및 현장 연동" 화면에서 상세정보와 함께 현장을 등록한다. 등록자가 그대로 소유자가 된다.
    @PostMapping("/api/sites/with-detail")
    @ResponseStatus(HttpStatus.CREATED)
    public SiteOwnerResponseDTO createWithDetail(@RequestBody SiteDetailRequestDTO request, HttpSession session) {
        Long loginUserId = requireLoginUserId(session);
        Site site = siteService.createWithDetail(request, loginUserId);
        return SiteOwnerResponseDTO.from(site);
    }

    // 원청이 자신이 등록한 현장만 모아보는 목록 (공유 코드 포함이라 본인 것만 조회 가능)
    @GetMapping("/api/sites/mine")
    public List<SiteOwnerResponseDTO> mine(HttpSession session) {
        return siteService.myOwnedSites(requireLoginUserId(session));
    }

    // 공유 코드 재발급. 소유자가 아닌 현장을 지정하면 서비스단에서 404로 처리된다.
    @PostMapping("/api/sites/{id}/invite-code/regenerate")
    public SiteOwnerResponseDTO regenerateInviteCode(@PathVariable Long id, HttpSession session) {
        return siteService.regenerateInviteCode(id, requireLoginUserId(session));
    }

    // 하청이 공유 코드를 입력해 현장에 입장한다.
    @PostMapping("/api/sites/join")
    public SiteConnectionResponseDTO join(@RequestBody JoinSiteRequestDTO request, HttpSession session) {
        return siteService.joinByInviteCode(request.inviteCode(), requireLoginUserId(session));
    }

    // 하청이 입장해 있는 현장 목록
    @GetMapping("/api/sites/joined")
    public List<SiteConnectionResponseDTO> joined(HttpSession session) {
        return siteService.joinedSites(requireLoginUserId(session));
    }

    // 원청이 자신의 현장들에 연결된 하청 업체 목록을 본다.
    @GetMapping("/api/sites/subcontractors")
    public List<ConnectedSubcontractorResponseDTO> connectedSubcontractors(HttpSession session) {
        return siteService.connectedSubcontractors(requireLoginUserId(session));
    }

    // 원청 전용: 현장을 영구 삭제한다. 소유자가 지정된 현장은 그 원청 본인만 삭제할 수 있다(서비스단에서 검증).
    @DeleteMapping("/api/sites/{id}")
    public Map<String, Boolean> delete(@PathVariable Long id, HttpSession session) {
        Long loginUserId = requirePrimeContractor(session);
        siteService.delete(id, loginUserId);
        return Map.of("ok", true);
    }

    private Long requireLoginUserId(HttpSession session) {
        Long loginUserId = (Long) session.getAttribute("LOGIN_USER_ID");
        if (loginUserId == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
        }
        return loginUserId;
    }

    private Long requirePrimeContractor(HttpSession session) {
        Long loginUserId = requireLoginUserId(session);
        boolean isPrimeContractor = userRepository.findById(loginUserId)
                .map(User::getRole)
                .filter(role -> role == UserRole.원청)
                .isPresent();
        if (!isPrimeContractor) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "원청만 현장을 삭제할 수 있습니다.");
        }
        return loginUserId;
    }
}
