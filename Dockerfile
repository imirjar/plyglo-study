# Stage 1: Build
FROM instrumentisto/flutter:3.35.0 AS build-env
WORKDIR /app
COPY . .
ARG APP_DOMAIN=dev.plyglo.com
ARG APP_SCHEME=http
ARG API_BASE_URL=
ARG AUTH_BASE_URL=
ARG KEYCLOAK_REALM=study
ARG KEYCLOAK_CLIENT_ID=frontend
RUN flutter build web --release \
    --dart-define=USE_PATH_URL_STRATEGY=true \
    --dart-define=APP_DOMAIN=${APP_DOMAIN} \
    --dart-define=APP_SCHEME=${APP_SCHEME} \
    --dart-define=API_BASE_URL=${API_BASE_URL} \
    --dart-define=AUTH_BASE_URL=${AUTH_BASE_URL} \
    --dart-define=KEYCLOAK_REALM=${KEYCLOAK_REALM} \
    --dart-define=KEYCLOAK_CLIENT_ID=${KEYCLOAK_CLIENT_ID}

# Stage 2: Serve
FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build-env /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
