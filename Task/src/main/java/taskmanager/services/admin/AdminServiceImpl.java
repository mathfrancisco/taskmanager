package taskmanager.services.admin;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.CrossOrigin;
import taskmanager.dto.CommentDto;
import taskmanager.dto.TaskDto;
import taskmanager.dto.UserDto;
import taskmanager.entities.Comment;
import taskmanager.entities.Task;
import taskmanager.entities.User;
import taskmanager.enums.TaskStatus;
import taskmanager.enums.UserRole;
import taskmanager.repositories.CommentRepository;
import taskmanager.repositories.TaskRepository;
import taskmanager.repositories.UserRepository;
import taskmanager.utils.JwtUtil;

import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@CrossOrigin("*")
public class AdminServiceImpl implements AdminService {

    private final UserRepository userRepository;

    private final TaskRepository taskRepository;

    private final JwtUtil jwtUtil;

    private final CommentRepository commentRepository;

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
        Optional<User> optionalUser = userRepository.findById(taskDto.getEmployeeId());
        if (optionalTask.isPresent() && optionalUser.isPresent()) {
            Task existingTask = optionalTask.get();
            existingTask.setTitle(taskDto.getTitle());
            existingTask.setDescription(taskDto.getDescription());
            existingTask.setDueDate(taskDto.getDueDate());
            existingTask.setPriority(taskDto.getPriority());
            existingTask.setTaskStatus(mapStringToTaskStatus(String.valueOf(taskDto.getTaskStatus())));
            existingTask.setUser(optionalUser.get());
            return taskRepository.save(existingTask).getTaskDto();
        }
        return null;
    }

    @Override
    public List<TaskDto> searchTaskByTitle(String title) {
        return taskRepository.findAllByTitleContaining(title)
                .stream()
                .sorted(Comparator.comparing(Task::getDueDate).reversed())
                .map(Task::getTaskDto)
                .collect(Collectors.toList());

    }

    @Override
    public CommentDto createComment(Long taskId, String content) {
         Optional<Task> optionalTask= taskRepository.findById(taskId);
         User user = jwtUtil.getLoggedInUser();
         if ((optionalTask.isPresent()) && user !=null) {
              Comment comment = new Comment();
              comment.setCreatedAt(new Date());
              comment.setContent(content);
              comment.setTask(optionalTask.get());
              comment.setUser(user);
              return commentRepository.save(comment).getCommentDto();
         }throw new EntityNotFoundException("User or task not found");
    }

    @Override
    public List<CommentDto> getCommentsByTaskId(Long taskId) {
        return commentRepository.findAllByTaskId(taskId).stream().map(Comment::getCommentDto).collect(Collectors.toList());
    }


    private TaskStatus mapStringToTaskStatus(String status) {
        return switch (status.toUpperCase()) {
            case "PENDING" -> TaskStatus.PENDING;
            case "INPROGRESS", "EMPROGRESSO" -> TaskStatus.INPROGRESS;
            case "COMPLETED", "COMPLETADA" -> TaskStatus.COMPLETED;
            case "DEFERRED", "DIFERIDA" -> TaskStatus.DEFERRED;
            case "CANCELLED" -> TaskStatus.CANCELLED;
            default -> throw new IllegalArgumentException("Status inválido: " + status);
        };
    }
}
