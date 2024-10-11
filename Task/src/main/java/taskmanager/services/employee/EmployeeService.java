package taskmanager.services.employee;

import taskmanager.dto.CommentDto;
import taskmanager.dto.TaskDto;

import java.util.List;

public interface EmployeeService {
    List<TaskDto> getTasksByUserId();

    TaskDto updateTask(Long id,String status);

    TaskDto getTaskById(Long id);

    CommentDto createComment(Long taskId, String content);

    List <CommentDto> getCommentsByTaskId(Long taskId);
}