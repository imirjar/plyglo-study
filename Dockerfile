# Stage 1: Build Flutter web
FROM instrumentisto/flutter:3.24.0 AS builder
WORKDIR /app
COPY . .
RUN flutter build web --release 
VOLUME /app/build/web 

