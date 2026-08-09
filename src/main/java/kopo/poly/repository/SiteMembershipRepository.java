package kopo.poly.repository;

import kopo.poly.entity.Site;
import kopo.poly.entity.SiteMembership;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface SiteMembershipRepository extends JpaRepository<SiteMembership, Long> {
    boolean existsBySiteAndUserId(Site site, Long userId);

    List<SiteMembership> findByUserIdOrderByJoinedAtDesc(Long userId);

    // 원청이 소유한 여러 현장에 소속된 하청 목록을 한 번에 보여주기 위한 조회
    List<SiteMembership> findBySiteOwnerIdOrderByJoinedAtDesc(Long ownerId);
}
