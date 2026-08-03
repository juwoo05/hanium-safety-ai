package kopo.poly.entity.enums;

import lombok.Getter;

@Getter
public enum UserRole {
    원청("CONTRACTOR"),
    하청("SUBCONTRACTOR");

    /** users.role ENUM('CONTRACTOR','SUBCONTRACTOR') 에 저장되는 값 */
    private final String dbValue;

    UserRole(String dbValue) {
        this.dbValue = dbValue;
    }
}
