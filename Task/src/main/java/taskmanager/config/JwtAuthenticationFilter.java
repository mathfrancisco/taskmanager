package taskmanager.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import org.apache.commons.lang3.StringUtils;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import taskmanager.services.jwt.UserService;
import taskmanager.utils.JwtUtil;

import java.io.IOException;

@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtUtil jwtUtil;
    private final UserService userService;

    @Override
    protected void doFilterInternal(@NonNull HttpServletRequest request,
                                    @NonNull HttpServletResponse response,
                                    @NonNull FilterChain filterChain)
            throws ServletException, IOException {
        final String authHeader = request.getHeader("Authorization");
        final String jwt;
        final String userEmail;

        // Verifica se o cabeçalho Authorization está ausente ou não começa com "Bearer"
        if (StringUtils.isEmpty(authHeader) || !StringUtils.startsWith(authHeader, "Bearer")) {
            filterChain.doFilter(request, response); // Continua a cadeia de filtros
            return; // Sai do método para evitar execução adicional
        }

        // Extrai o token JWT do cabeçalho (a partir do 7º caractere para remover "Bearer ")
        jwt = authHeader.substring(7);
        userEmail = jwtUtil.extractUserName(jwt); // Extrai o nome de usuário do token JWT

        // Se o email foi extraído e o usuário ainda não está autenticado no contexto
        if (StringUtils.isNotEmpty(userEmail) && SecurityContextHolder.getContext().getAuthentication() == null) {
            UserDetails userDetails = userService.userDetailsService().loadUserByUsername(userEmail);

            // Verifica se o token é válido
            if (jwtUtil.isTokenValid(jwt, userDetails)) {
                // Configura a autenticação no contexto de segurança
                SecurityContext context = SecurityContextHolder.createEmptyContext();
                UsernamePasswordAuthenticationToken authToken =
                        new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
                authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                context.setAuthentication(authToken);
                SecurityContextHolder.setContext(context);
            }
        }

        // Continua a cadeia de filtros
        filterChain.doFilter(request, response);
    }
}

