# Stage 1: Build Flutter web
FROM instrumentisto/flutter:latest
WORKDIR /app
COPY . .
RUN flutter build web --release 
VOLUME /app/build/web 

