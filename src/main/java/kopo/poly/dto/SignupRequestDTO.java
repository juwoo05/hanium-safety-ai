package kopo.poly.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SignupRequestDTO {
    private String name;
    private String password;
    private String passwordConfirm;
    private String email;
    private String company;
    private String role; //contractor(원청) / subcontractor(하청)
}
