package taskmanager.controller.auth;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;
import taskmanager.dto.AuthenticationRequest;
import taskmanager.dto.AuthenticationResponse;
import taskmanager.dto.SignupRequest;
import taskmanager.dto.UserDto;
import taskmanager.entities.User;
import taskmanager.repositories.UserRepository;
import taskmanager.services.auth.AuthService;
import taskmanager.services.jwt.UserService;
import taskmanager.utils.JwtUtil;

import java.util.Optional;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@CrossOrigin(origins = "http://localhost:4200", allowCredentials = "true")
public class AuthController {

    private final AuthService authService;

    private final UserRepository userRepository;

    private final JwtUtil jwtUtil;

    private final UserService userService;

    private final AuthenticationManager authenticationManager;

    @PostMapping("/signup")
    public ResponseEntity<?> signupUser(@RequestBody SignupRequest signupRequest) {
        if (authService.hasUserWithEmail(signupRequest.getEmail())) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("User already exists with this email");
        }
        UserDto createdUserDto = authService.signupUser(signupRequest);
        if (createdUserDto == null) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("User could not be created");
        }
        return ResponseEntity.status(HttpStatus.CREATED).body(createdUserDto); // Certifique-se de que createdUserDto contém os dados corretos.
    }

    @PostMapping("/login")
    public AuthenticationResponse login(@RequestBody AuthenticationRequest authenticationRequest){
       try {
          authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(authenticationRequest.getEmail(), authenticationRequest.getPassword()));
       }catch (BadCredentialsException e){
        throw new BadCredentialsException("Invalid username or password");
    }final UserDetails userDetails = userService.userDetailsService().loadUserByUsername(authenticationRequest.getEmail());
      Optional<User> optionalUser = userRepository.findFirstByEmail(authenticationRequest.getEmail());
      final String jwtToken = jwtUtil.generateToken(userDetails);
      AuthenticationResponse authenticationResponse = new AuthenticationResponse();
      if (optionalUser.isPresent()) {authenticationResponse.setJwt(jwtToken);
          authenticationResponse.setUserId(optionalUser.get().getId());
          authenticationResponse.setUserRole(optionalUser.get().getUserRole());}
      return authenticationResponse;
    }


}
