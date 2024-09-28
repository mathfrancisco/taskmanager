package taskmanager.dto;

import lombok.Data;
import taskmanager.enums.UserRole;

@Data
public class AuthenticationResponse {

    private String jwt;

    private Long userId;

    private UserRole userRole;


}
