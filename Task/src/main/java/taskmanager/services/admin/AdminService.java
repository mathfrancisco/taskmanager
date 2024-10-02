package taskmanager.services.admin;

import taskmanager.dto.TaskDto;
import taskmanager.dto.UserDto;

import java.util.List;

public interface AdminService {

    List<UserDto> getUsers();

    TaskDto createTask(TaskDto taskDto);
}
