package kopo.poly.service;

import kopo.poly.dto.request.SiteCreateRequest;
import kopo.poly.dto.response.SiteResponse;
import kopo.poly.entity.Site;

import java.util.List;

public interface ISiteService {

    // 각 현장의 최근 위험도는 그 현장에서 가장 최근에 실시된 점검 결과를 보여준다.
    List<SiteResponse> list();

    Site create(SiteCreateRequest request);
}
