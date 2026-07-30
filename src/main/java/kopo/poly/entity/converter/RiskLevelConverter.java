package kopo.poly.entity.converter;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;
import kopo.poly.entity.enums.RiskLevel;

import java.util.Arrays;

// DB의 risk_level 컬럼은 ENUM('고위험','중위험','안전')이라, Java enum 상수명(HIGH/MEDIUM/SAFE)과
// DB 저장값(한글 라벨)을 서로 변환해준다.
@Converter
public class RiskLevelConverter implements AttributeConverter<RiskLevel, String> {

    @Override
    public String convertToDatabaseColumn(RiskLevel attribute) {
        return attribute == null ? null : attribute.getLabel();
    }

    @Override
    public RiskLevel convertToEntityAttribute(String dbData) {
        if (dbData == null) {
            return null;
        }
        return Arrays.stream(RiskLevel.values())
                .filter(level -> level.getLabel().equals(dbData))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("알 수 없는 위험도 값: " + dbData));
    }
}
