package taskmanager.services.admin;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import taskmanager.dto.UserDto;
import taskmanager.entities.User;
import taskmanager.enums.UserRole;
import taskmanager.repositories.UserRepository;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AdminServiceImpl implements AdminService {
    private final UserRepository userRepository;

    @Override
    public List<UserDto> getUsers() {
        return userRepository.findAll()
                .stream()
                .filter(user -> user.getUserRole()== UserRole.EMPLOYEE)
                .map(User::getUserDto)
                .collect(Collectors.toList());
    }
}
