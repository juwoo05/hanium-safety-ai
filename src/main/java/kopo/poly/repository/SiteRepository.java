package kopo.poly.repository;

import kopo.poly.entity.Site;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface SiteRepository extends JpaRepository<Site, Long> {
    List<Site> findAllByOrderByNameAsc();

    List<Site> findByOwnerIdOrderByNameAsc(Long ownerId);

    Optional<Site> findByInviteCode(String inviteCode);

    boolean existsByInviteCode(String inviteCode);
}
