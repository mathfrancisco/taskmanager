package taskmanager.services.admin;

import taskmanager.dto.CommentDto;
import taskmanager.dto.TaskDto;
import taskmanager.dto.UserDto;

import java.util.List;

public interface AdminService {

    List<UserDto> getUsers();

    TaskDto createTask(TaskDto taskDto);

    List<TaskDto> getAllTasks();

    void deleteTask(Long id);

    TaskDto getTaskById(Long id);

    TaskDto updateTask(Long id,TaskDto taskDto);

    List<TaskDto> searchTaskByTitle(String title);

    CommentDto createComment(Long taskId, String content);

    List <CommentDto> getCommentsByTaskId(Long taskId);
}
