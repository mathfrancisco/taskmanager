package taskmanager.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import taskmanager.entities.Comment;

@Repository
public interface CommentRepository extends JpaRepository<Comment, Long> {

}
