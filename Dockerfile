# Stage 1: Build Flutter web
FROM ghcr.io/gmeligio/flutter-web:3.44.8
WORKDIR /app
COPY . .
RUN flutter build web --release 
VOLUME /app/build/web 

