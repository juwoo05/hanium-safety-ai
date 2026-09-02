package kopo.poly.dto.request;

public record CompanyProfileUpdateRequestDTO(
        String companyName,
        String companyBizNo,
        String companyCeoName,
        String companyAddress
) {
}
