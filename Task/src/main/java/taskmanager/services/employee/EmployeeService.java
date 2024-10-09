package taskmanager.services.employee;

import taskmanager.dto.TaskDto;

import java.util.List;

public interface EmployeeService {
    List<TaskDto> getTasksByUserId();

}