package kopo.poly.service;

import kopo.poly.dto.request.SiteCreateRequest;
import kopo.poly.dto.request.SiteDetailRequest;
import kopo.poly.dto.response.ConnectedSubcontractorResponse;
import kopo.poly.dto.response.SiteConnectionResponse;
import kopo.poly.dto.response.SiteOwnerResponse;
import kopo.poly.dto.response.SiteResponse;
import kopo.poly.entity.Site;

import java.util.List;

public interface ISiteService {

    // 각 현장의 최근 위험도는 그 현장에서 가장 최근에 실시된 점검 결과를 보여준다.
    List<SiteResponse> list();

    Site create(SiteCreateRequest request);

    // 원청이 "건설사 및 현장 연동" 화면에서 현장을 상세정보와 함께 새로 등록한다.
    Site createWithDetail(SiteDetailRequest request, Long ownerId);

    // 원청이 자신이 등록한 현장만 모아보는 목록 (공유 코드 포함)
    List<SiteOwnerResponse> myOwnedSites(Long ownerId);

    // 공유 코드 재발급. 본인 소유 현장이 아니면 거부한다.
    SiteOwnerResponse regenerateInviteCode(Long siteId, Long ownerId);

    // 하청이 공유 코드를 입력해 현장에 입장한다.
    SiteConnectionResponse joinByInviteCode(String inviteCode, Long userId);

    // 하청이 입장한 현장 목록
    List<SiteConnectionResponse> joinedSites(Long userId);

    // 원청이 자신의 현장들에 연결된 하청 업체 목록을 본다.
    List<ConnectedSubcontractorResponse> connectedSubcontractors(Long ownerId);
}
