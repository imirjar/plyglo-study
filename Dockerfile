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

# Stage 2: Serve with Caddy
FROM caddy:alpine

# Копируем Caddyfile
COPY Caddyfile /etc/caddy/Caddyfile

# Копируем собранный Flutter
COPY --from=builder /app/build/web /usr/share/caddy

# Caddy по умолчанию слушает 80 порт
EXPOSE 80
