package kopo.poly.controller.api;

import jakarta.servlet.http.HttpSession;
import kopo.poly.dto.request.JoinSiteRequest;
import kopo.poly.dto.request.SiteCreateRequest;
import kopo.poly.dto.request.SiteDetailRequest;
import kopo.poly.dto.response.ConnectedSubcontractorResponse;
import kopo.poly.dto.response.SiteConnectionResponse;
import kopo.poly.dto.response.SiteOwnerResponse;
import kopo.poly.dto.response.SiteResponse;
import kopo.poly.entity.Site;
import kopo.poly.service.ISiteService;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@RestController
public class SiteApiController {

    private final ISiteService siteService;

    public SiteApiController(ISiteService siteService) {
        this.siteService = siteService;
    }

    @GetMapping("/api/sites")
    public List<SiteResponse> list(HttpSession session) {
        requireLoginUserId(session);
        return siteService.list();
    }

    @PostMapping("/api/sites")
    @ResponseStatus(HttpStatus.CREATED)
    public SiteResponse create(@RequestBody SiteCreateRequest request, HttpSession session) {
        requireLoginUserId(session);
        Site site = siteService.create(request);
        return SiteResponse.from(site, null);
    }

    // 원청이 "건설사 및 현장 연동" 화면에서 상세정보와 함께 현장을 등록한다. 등록자가 그대로 소유자가 된다.
    @PostMapping("/api/sites/with-detail")
    @ResponseStatus(HttpStatus.CREATED)
    public SiteOwnerResponse createWithDetail(@RequestBody SiteDetailRequest request, HttpSession session) {
        Long loginUserId = requireLoginUserId(session);
        Site site = siteService.createWithDetail(request, loginUserId);
        return SiteOwnerResponse.from(site);
    }

    // 원청이 자신이 등록한 현장만 모아보는 목록 (공유 코드 포함이라 본인 것만 조회 가능)
    @GetMapping("/api/sites/mine")
    public List<SiteOwnerResponse> mine(HttpSession session) {
        return siteService.myOwnedSites(requireLoginUserId(session));
    }

    // 공유 코드 재발급. 소유자가 아닌 현장을 지정하면 서비스단에서 404로 처리된다.
    @PostMapping("/api/sites/{id}/invite-code/regenerate")
    public SiteOwnerResponse regenerateInviteCode(@PathVariable Long id, HttpSession session) {
        return siteService.regenerateInviteCode(id, requireLoginUserId(session));
    }

    // 하청이 공유 코드를 입력해 현장에 입장한다.
    @PostMapping("/api/sites/join")
    public SiteConnectionResponse join(@RequestBody JoinSiteRequest request, HttpSession session) {
        return siteService.joinByInviteCode(request.inviteCode(), requireLoginUserId(session));
    }

    // 하청이 입장해 있는 현장 목록
    @GetMapping("/api/sites/joined")
    public List<SiteConnectionResponse> joined(HttpSession session) {
        return siteService.joinedSites(requireLoginUserId(session));
    }

    // 원청이 자신의 현장들에 연결된 하청 업체 목록을 본다.
    @GetMapping("/api/sites/subcontractors")
    public List<ConnectedSubcontractorResponse> connectedSubcontractors(HttpSession session) {
        return siteService.connectedSubcontractors(requireLoginUserId(session));
    }

    private Long requireLoginUserId(HttpSession session) {
        Long loginUserId = (Long) session.getAttribute("LOGIN_USER_ID");
        if (loginUserId == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
        }
        return loginUserId;
    }
}
