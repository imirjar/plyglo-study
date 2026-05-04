# Stage 1: Build
FROM instrumentisto/flutter:3.35.0 AS build-env
WORKDIR /app
COPY . .
RUN flutter build web --release --dart-define=USE_PATH_URL_STRATEGY=true

# Stage 2: Serve
FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build-env /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
