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

- **Diagrama Geral**:
  - Este diagrama exemplifica a arquitetura geral da aplicação, incluindo o frontend, backend, banco de dados, e a infraestrutura baseada na AWS:

  ![Diagrama de Sequência](link_para_diagrama_sequencia)


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

- **Terraform**:
   - Ferramenta para provisionamento de infraestrutura como código (IaC). Com o Terraform, é possível configurar automaticamente os recursos da **AWS** necessários para a aplicação, como Elastic Beanstalk e bancos de dados.
- **AWS Elastic Beanstalk**:
   - Plataforma da AWS para o deploy e gerenciamento de aplicações. A aplicação será implantada no Elastic Beanstalk, facilitando o escalonamento e a gestão de infraestrutura.

## 🚧 Deploy

 - **A implantação da aplicação utiliza Docker, Terraform e AWS Elastic Beanstalk. Siga os passos abaixo para o deploy:**

1. Faça o build da aplicação usando o Maven.
2. Crie a imagem Docker do backend e frontend.
3. Use o Terraform para provisionar a infraestrutura necessária no AWS Elastic Beanstalk.
4. Implante as imagens Docker no Elastic Beanstalk.

## 👥 Dados de Acesso (para testes)

- **Usuário Admin**:
  - Email: admin@test.com
  - Senha: admin

- **Usuário Comum**:
  - Email: ari@test.com
  - Senha: ari

## 📜 Licença

Este projeto está licenciado sob a [MIT License](LICENSE).

## 👨‍💻 Autor

- Matheus Francisco - [GitHub](https://github.com/mathfrancisco)
