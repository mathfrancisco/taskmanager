# 📝 TaskManager

O **TaskManager** é uma aplicação voltada para a organização e gestão de tarefas. Ele permite aos usuários criar, atualizar e gerenciar suas tarefas de maneira eficiente, com uma interface intuitiva e funcionalidades robustas de autenticação e segurança.

## 📌 Funcionalidades

- **Gerenciamento de Tarefas**: 
  - Criação, edição e remoção de tarefas.
  - Marcar tarefas como concluídas.
  - Filtros para visualizar tarefas pendentes ou concluídas.

- **Autenticação e Autorização**:
  - Registro e login de usuários.
  - Proteção das rotas da aplicação usando JWT.
  - Diferentes níveis de acesso para administradores e usuários comuns.

- **Perfis de Usuário**:
  - Visualização e edição do perfil de usuário.
  - Recuperação de senha.

- **Gerenciamento de Projetos**: 
  - Criação e administração de projetos.
  - Adição de tarefas a projetos específicos.

## 🎨 Diagramas UML

- **Diagrama de Sequência**:

  ![Diagrama de Sequência](link_para_diagrama_sequencia)

- **Diagrama de Caso de Uso**:

  ![Diagrama de Caso de Uso](link_para_diagrama_caso_uso)

- **Diagrama de Classes**:

  ![Diagrama de Classes](link_para_diagrama_classes)

- **Diagrama de Banco de Dados**:

  ![Diagrama de Banco de Dados](link_para_diagrama_banco_dados)

## 🚀 Tecnologias Utilizadas

- **Backend**:
  - Java
  - Spring Boot
  - Spring Data JPA
  - Spring Security
  - JWT (JSON Web Tokens)
  - Lombok
  
- **Frontend**:
  - Angular
  
- **Banco de Dados**:
  - MySQL
  
- **Infraestrutura**:
  - Docker
  - AWS (Amazon Web Services) para deploy

## 🚧 Deploy

A aplicação está configurada para ser implantada usando Docker e AWS. Siga os passos abaixo para implantar:

1. Faça o build da aplicação usando o Maven.
2. Crie a imagem Docker do backend e frontend.
3. Implante as imagens em uma instância EC2 da AWS.
4. O banco de dados está hospedado em uma instância do RDS na AWS.

## 👥 Dados de Acesso (para testes)

- **Usuário Admin**:
  - Email: admin@taskmanager.com
  - Senha: admin123

- **Usuário Comum**:
  - Email: user@taskmanager.com
  - Senha: user123

## 📜 Licença

Este projeto está licenciado sob a [MIT License](LICENSE).

## 👨‍💻 Autor

- Matheus Francisco - [GitHub](https://github.com/mathfrancisco)
