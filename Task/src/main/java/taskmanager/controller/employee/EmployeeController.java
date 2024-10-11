package taskmanager.controller.employee;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import taskmanager.dto.CommentDto;
import taskmanager.dto.TaskDto;
import taskmanager.services.employee.EmployeeService;

import java.util.List;

@RestController
@RequestMapping("/api/employee")
@RequiredArgsConstructor
public class EmployeeController {

    private final EmployeeService employeeService;


    @GetMapping("/tasks")
    public ResponseEntity<List<TaskDto>> getTasksByUserId(){
        return ResponseEntity.ok(employeeService.getTasksByUserId());
    }

    @GetMapping("/task/{id}/{status}")
    public ResponseEntity<TaskDto> updateTask(@PathVariable Long id, @PathVariable String status){
       TaskDto updateTaskDto = employeeService.updateTask(id,status);
       if (updateTaskDto == null)
           return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
       return ResponseEntity.ok(updateTaskDto);

    }
    @GetMapping("/task/{id}")
    public ResponseEntity<TaskDto> getTaskById(@PathVariable Long id){
        return ResponseEntity.ok(employeeService.getTaskById(id));
    }
    @PostMapping("/task/comment/{taskId}")
    public ResponseEntity<CommentDto> createComment(@PathVariable Long taskId, @RequestBody String content){
        CommentDto createdCommentDto =employeeService.createComment(taskId,content);
        if(createdCommentDto ==null)return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        return ResponseEntity.status(HttpStatus.CREATED).body(createdCommentDto);
    }

    @GetMapping("comments/{taskId}")
    public ResponseEntity <List<CommentDto>> getCommentsByTaskId(@PathVariable Long taskId){
        return ResponseEntity.ok(employeeService.getCommentsByTaskId(taskId));
    }
}
