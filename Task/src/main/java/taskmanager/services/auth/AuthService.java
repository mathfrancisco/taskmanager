package taskmanager.services.auth;

import taskmanager.dto.SignupRequest;
import taskmanager.dto.UserDto;

public interface AuthService {

    UserDto signupUser(SignupRequest signupRequest);

    boolean hasUserWithEmail(String email);
}
