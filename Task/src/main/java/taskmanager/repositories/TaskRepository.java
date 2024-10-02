package taskmanager.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import taskmanager.entities.Task;

@Repository
public interface TaskRepository extends JpaRepository<Task, Long> {
}
