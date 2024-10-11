# Frontend Dockerfile (taskfront/task_angular/Dockerfile)
# Stage 1: Build the Angular application
FROM node:18 AS build-stage
WORKDIR /app
COPY package*.json ./
RUN npm cache clean --force && npm install
RUN npm install -g @angular/cli@16.2.14
COPY . .
RUN ng build --configuration production

# Stage 2: Serve the application using Nginx
FROM nginx:alpine
COPY --from=build-stage /app/dist/task_angular /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
