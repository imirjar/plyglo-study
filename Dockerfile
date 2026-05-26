# Stage 1: Build Flutter web
FROM instrumentisto/flutter:3.41.6 AS builder
WORKDIR /app
COPY . .
RUN flutter build web --release

# Stage 2: Serve with Caddy
FROM caddy:alpine

# Копируем Caddyfile
COPY Caddyfile /etc/caddy/Caddyfile

# Копируем собранный Flutter
COPY --from=builder /app/build/web /usr/share/caddy

# Caddy по умолчанию слушает 80 порт
EXPOSE 80