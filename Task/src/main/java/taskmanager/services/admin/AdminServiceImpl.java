package taskmanager.services.admin;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.CrossOrigin;
import taskmanager.dto.TaskDto;
import taskmanager.dto.UserDto;
import taskmanager.entities.Task;
import taskmanager.entities.User;
import taskmanager.enums.TaskStatus;
import taskmanager.enums.UserRole;
import taskmanager.repositories.TaskRepository;
import taskmanager.repositories.UserRepository;

import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@CrossOrigin("*")
public class AdminServiceImpl implements AdminService {
    private final UserRepository userRepository;

    private final TaskRepository taskRepository;

    @Override
    public List<UserDto> getUsers() {
        return userRepository.findAll()
                .stream()
                .filter(user -> user.getUserRole()== UserRole.EMPLOYEE)
                .map(User::getUserDto)
                .collect(Collectors.toList());
    }

    @Override
    public TaskDto createTask(TaskDto taskDto) {
        Optional<User> optionalUser = userRepository.findById(taskDto.getEmployeeId());
        if (optionalUser.isPresent() ) {
            Task task = new Task();
            task.setTitle(taskDto.getTitle());
            task.setDescription(taskDto.getDescription());
            task.setPriority(taskDto.getPriority());
            task.setDueDate(taskDto.getDueDate());
            task.setTaskStatus(TaskStatus.INPROGRESS);
            task.setUser(optionalUser.get());
            return taskRepository.save(task).getTaskDto();


        }

        return null;
    }

    @Override
    public List<TaskDto> getAllTasks() {
        return taskRepository.findAll()
                .stream()
                .sorted(Comparator.comparing(Task::getDueDate).reversed())
                .map(Task::getTaskDto)
                .collect(Collectors.toList());
    }

    @Override
    public void deleteTask(Long id) {
        taskRepository.deleteById(id);
    }

    @Override
    public TaskDto getTaskById(Long id) {
        Optional<Task> optionalTask = taskRepository.findById(id);
        return optionalTask.map(Task::getTaskDto).orElse(null);
    }

    @Override
    public TaskDto updateTask(Long id, TaskDto taskDto) {
        Optional<Task> optionalTask = taskRepository.findById(id);
        if (optionalTask.isPresent()) {
            Task existingtask = optionalTask.get();
            existingtask.setTitle(taskDto.getTitle());
            existingtask.setDescription(taskDto.getDescription());
            existingtask.setDueDate(taskDto.getDueDate());
            existingtask.setPriority(taskDto.getPriority());
            existingtask.setTaskStatus(mapStringToTaskStatus(String.valueOf(taskDto.getTaskStatus())));
            return taskRepository.save(existingtask).getTaskDto();
        }
        return null;
    }
    private  TaskStatus mapStringToTaskStatus(String status){
         return switch (status){
            case "PENDENTE"-> TaskStatus.PENDING;
            case "EM PROGRESSO"-> TaskStatus.INPROGRESS;
            case "COMPLETADA"-> TaskStatus.COMPLETED;
            case "DIFERIDA"-> TaskStatus.DEFERRED;
             default -> TaskStatus.CANCELLED;
        };
    }
}
