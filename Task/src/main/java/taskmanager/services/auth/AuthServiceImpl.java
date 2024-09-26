package taskmanager.services.auth;

import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import taskmanager.entities.User;
import taskmanager.enums.UserRole;
import taskmanager.repositories.UserRepository;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService{

    private final UserRepository userRepository;

    @PostConstruct

    public void createAnAdminAccount(){
        Optional <User> optionalUser = userRepository.findByUserRole(UserRole.ADMIN);
        if (optionalUser.isEmpty()){
         User user = new User();
         user.setEmail("admin@test.com");
         user.setName("admin");
         user.setPassword(new BCryptPasswordEncoder().encode("admin"));
         user.setUserRole(UserRole.ADMIN);
         userRepository.save(user);
            System.out.println("Admin account created successfully");
        }else {
            System.out.println("Admin account already exists");
        }
    }

}
