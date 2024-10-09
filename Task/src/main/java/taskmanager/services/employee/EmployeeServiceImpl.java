package taskmanager.services.employee;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import taskmanager.dto.TaskDto;
import taskmanager.entities.Task;
import taskmanager.entities.User;
import taskmanager.repositories.TaskRepository;
import taskmanager.utils.JwtUtil;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class EmployeeServiceImpl implements EmployeeService {
    private final TaskRepository taskRepository;
    private final JwtUtil jwtUtil;

    @Override
    public List<TaskDto> getTasksByUserId() {
        User user = jwtUtil.getLoggedInUser();
        if (user != null) {
            return taskRepository.findAllByUserId(user.getId())
                    .stream()
                    .sorted(Comparator.comparing(Task::getDueDate).reversed())
                    .map(Task::getTaskDto)  // Explicit casting
                    .collect(Collectors.toList());
        }
        throw new EntityNotFoundException("User not found");
    }
}


