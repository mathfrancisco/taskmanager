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

    @GetMapping("/tasks")
    public ResponseEntity<?> getAllTasks(){
        return ResponseEntity.ok(adminService.getAllTasks());
    }

  @DeleteMapping("/task/{id}")
  public ResponseEntity<Void> deleteTask(@PathVariable Long id){
        adminService.deleteTask(id);
        return ResponseEntity.ok(null);
  }
  @GetMapping("/task/{id}")
  public ResponseEntity<TaskDto> getTaskById(@PathVariable Long id){
       return ResponseEntity.ok(adminService.getTaskById(id));
  }
  @PutMapping("/task/{id}")
  public ResponseEntity<?>updateTask(@PathVariable Long id,@RequestBody TaskDto taskDto){
        TaskDto updateTask= adminService.updateTask(id,taskDto);
        if(updateTask ==null)return ResponseEntity.notFound().build();
        return ResponseEntity.ok(updateTask);
  }
}
