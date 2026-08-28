package kopo.poly.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * Figma에서 export된 SafeMate React(Vite) 프론트엔드를 서빙한다.
 * 빌드 산출물은 {@code src/main/resources/static/app/} 에 위치하며 {@code /app/} 경로로 접근한다.
 * SPA는 App.tsx의 상태 기반 라우팅을 쓰므로 진입점(index.html)만 forward 하면 된다.
 */
@Controller
public class SpaController {

    @GetMapping({"/app", "/app/"})
    public String safemateApp() {
        return "forward:/app/index.html";
    }
}
