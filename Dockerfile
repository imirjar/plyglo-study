# Stage 1: Build Flutter web
FROM instrumentisto/flutter:3.24.0 AS builder
WORKDIR /app
COPY . .
ARG API_BASE_URL=https://api.plyglo.com
ARG AUTH_BASE_URL=https://auth.plyglo.com
ARG KEYCLOAK_REALM=study
RUN flutter build web --release \
  --dart-define=API_BASE_URL=${API_BASE_URL} \
  --dart-define=AUTH_BASE_URL=${AUTH_BASE_URL} \
  --dart-define=KEYCLOAK_REALM=${KEYCLOAK_REALM}

VOLUME /app/build/web 

