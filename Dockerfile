# Stage 1: Build
FROM instrumentisto/flutter:3.35.0 AS build-env
WORKDIR /app
COPY . .
ARG KEYCLOAK_BASE_URL=/api
ARG KEYCLOAK_REALM=study
ARG KEYCLOAK_CLIENT_ID=frontend
ARG COURSES_BASE_URL=/api
RUN flutter build web --release \
    --dart-define=USE_PATH_URL_STRATEGY=true \
    --dart-define=KEYCLOAK_BASE_URL=${KEYCLOAK_BASE_URL} \
    --dart-define=KEYCLOAK_REALM=${KEYCLOAK_REALM} \
    --dart-define=KEYCLOAK_CLIENT_ID=${KEYCLOAK_CLIENT_ID} \
    --dart-define=COURSES_BASE_URL=${COURSES_BASE_URL}

# Stage 2: Serve
FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build-env /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
