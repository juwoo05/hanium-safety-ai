package kopo.poly.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.JdkClientHttpRequestFactory;
import org.springframework.web.client.RestClient;

import java.net.http.HttpClient;

@Configuration
public class AiPipelineClientConfig {

    @Bean
    public RestClient aiPipelineRestClient(
            @Value("${ai-pipeline.base-url}") String baseUrl,
            @Value("${ai-pipeline.api-key}") String apiKey
    ) {
        // JDK HttpClient는 평문 HTTP에도 기본적으로 h2c(HTTP/2 업그레이드)를 시도하는데,
        // uvicorn(FastAPI)이 이를 제대로 처리하지 못해 멀티파트 업로드 본문이 씹히는 문제가 있었다.
        // HTTP/1.1로 고정해서 우회한다.
        HttpClient httpClient = HttpClient.newBuilder()
                .version(HttpClient.Version.HTTP_1_1)
                .build();

        return RestClient.builder()
                .baseUrl(baseUrl)
                .defaultHeader("X-API-Key", apiKey)
                .requestFactory(new JdkClientHttpRequestFactory(httpClient))
                .build();
    }
}
