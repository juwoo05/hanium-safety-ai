package kopo.poly.entity.converter;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;
import kopo.poly.entity.enums.UserRole;

import java.util.Arrays;

@Converter
public class UserRoleConverter implements AttributeConverter<UserRole, String> {

    @Override
    public String convertToDatabaseColumn(UserRole attribute) {
        return attribute == null ? null : attribute.getDbValue();
    }

    @Override
    public UserRole convertToEntityAttribute(String dbData) {
        if (dbData == null) {
            return null;
        }
        return Arrays.stream(UserRole.values())
                .filter(role -> role.getDbValue().equals(dbData))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("알 수 없는 역할 값: " + dbData));
    }
}
