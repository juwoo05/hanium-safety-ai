package kopo.poly.dto.request;

public record CompanyProfileUpdateRequest(
        String companyName,
        String companyBizNo,
        String companyCeoName,
        String companyAddress
) {
}
