# Stage 1: Build Flutter web
FROM instrumentisto/flutter:3.41.6
WORKDIR /app
COPY . .
RUN flutter build web --release 
VOLUME /app/build/web 

