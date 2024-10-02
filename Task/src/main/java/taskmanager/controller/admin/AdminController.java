package taskmanager.controller.admin;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import taskmanager.dto.TaskDto;
import taskmanager.services.admin.AdminService;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/admin")
public class AdminController {
    private final AdminService adminService;

    @GetMapping("/users")
    public ResponseEntity<?> getUsers(){
        return ResponseEntity.ok(adminService.getUsers());
    }

  @PostMapping("/task")
  public ResponseEntity<TaskDto> createTask(@RequestBody TaskDto taskDto){TaskDto createdTaskDto =adminService.createTask(taskDto);
      if(createdTaskDto ==null)return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
      return ResponseEntity.status(HttpStatus.CREATED).body(createdTaskDto);
    }


}
