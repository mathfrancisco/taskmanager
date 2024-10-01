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

### **Backend**

- **Java**:
  - A linguagem de programação usada para construir o backend da aplicação. Java oferece forte tipagem, multithreading e segurança, sendo ideal para desenvolvimento de aplicações corporativas robustas.

- **Spring Boot**:
  - Um framework Java que simplifica a criação de aplicações web. Ele facilita a configuração do servidor, gerenciamento de dependências e oferece uma estrutura de fácil implementação para REST APIs.

- **Spring Data JPA**:
  - Módulo do Spring que permite a interação com o banco de dados de forma mais simples e eficiente. Ele abstrai grande parte do código necessário para CRUD e consultas, permitindo que o desenvolvedor foque nas regras de negócio.

- **Spring Security**:
  - Um módulo do Spring para gerenciar autenticação e autorização. Ele protege as rotas da aplicação, permitindo acesso apenas a usuários autenticados e controlando os privilégios de cada usuário (admin, usuário comum).

- **JWT (JSON Web Tokens)**:
  - JWT é usado para autenticação de usuários, onde um token é gerado após o login e incluído nas requisições subsequentes para verificar a identidade do usuário. É um método eficiente para controlar sessões sem a necessidade de manter estado no servidor.

- **Lombok**:
  - Biblioteca que simplifica a escrita de código Java, gerando automaticamente métodos como getters, setters, equals e hashCode, entre outros, através de anotações, reduzindo o boilerplate code.

### **Frontend**

- **Angular**:
  - Framework JavaScript para desenvolvimento de aplicações frontend. Ele facilita a criação de interfaces dinâmicas e reativas, permitindo a comunicação eficiente com o backend por meio de serviços HTTP.

### **Banco de Dados**

- **MySQL**:
  - Banco de dados relacional usado para armazenar as informações da aplicação, como usuários, tarefas, projetos, etc. O MySQL é confiável e amplamente utilizado, suportando operações complexas e alta performance.

### **Infraestrutura**

- **Docker**:
  - Ferramenta de containerização que permite empacotar a aplicação com todas as suas dependências, garantindo que ela rode da mesma forma em qualquer ambiente. Docker facilita o processo de deploy, permitindo que a aplicação seja executada de maneira consistente em diferentes sistemas.

- **AWS (Amazon Web Services)**:
  - Plataforma de serviços em nuvem onde a aplicação é hospedada. A AWS oferece uma infraestrutura escalável e segura para rodar a aplicação, além de serviços como RDS (para banco de dados) e EC2 (para execução de contêineres e instâncias).

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
