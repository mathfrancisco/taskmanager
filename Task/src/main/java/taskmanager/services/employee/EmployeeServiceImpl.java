package taskmanager.services.employee;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import taskmanager.dto.CommentDto;
import taskmanager.dto.TaskDto;
import taskmanager.entities.Comment;
import taskmanager.entities.Task;
import taskmanager.entities.User;
import taskmanager.enums.TaskStatus;
import taskmanager.repositories.CommentRepository;
import taskmanager.repositories.TaskRepository;
import taskmanager.utils.JwtUtil;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class EmployeeServiceImpl implements EmployeeService {
    private final TaskRepository taskRepository;
    private final JwtUtil jwtUtil;
    private final CommentRepository commentRepository;

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

    @Override
    public TaskDto updateTask(Long id, String status) {
         Optional<Task> optionalTask = taskRepository.findById(id);
         if (optionalTask.isPresent()) {
             Task existingTask = optionalTask.get();
             existingTask.setTaskStatus(mapStringToTaskStatus(status));
             return taskRepository.save(existingTask).getTaskDto();
         }
         throw new EntityNotFoundException("Task not found");

    }
    @Override
    public TaskDto getTaskById(Long id) {
        Optional<Task> optionalTask = taskRepository.findById(id);
        return optionalTask.map(Task::getTaskDto).orElse(null);
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


