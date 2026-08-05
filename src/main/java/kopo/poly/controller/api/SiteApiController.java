package kopo.poly.controller.api;

import jakarta.servlet.http.HttpSession;
import kopo.poly.dto.request.SiteCreateRequest;
import kopo.poly.dto.response.SiteResponse;
import kopo.poly.entity.Site;
import kopo.poly.service.ISiteService;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
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

    private void requireLoginUserId(HttpSession session) {
        if (session.getAttribute("LOGIN_USER_ID") == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
        }
    }
}
