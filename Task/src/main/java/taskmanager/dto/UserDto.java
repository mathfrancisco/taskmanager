package taskmanager.dto;

import lombok.Data;
import taskmanager.enums.UserRole;

@Data
public class UserDto {

    private Long id;

    private String name;
    private String email;
    private String password;

    private UserRole userRole;
}
