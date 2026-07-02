package kopo.poly.repository;

import kopo.poly.entity.Company;
import kopo.poly.entity.enums.CompanyType;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CompanyRepository extends JpaRepository<Company, Long> {
    List<Company> findByType(CompanyType type);
}