FROM cirrusci/flutter:stable AS build

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get
COPY . .
RUN flutter build web --release

FROM caddy:alpine
COPY --from=build /app/build/web /srv
COPY Caddyfile /etc/caddy/Caddyfile

# Явно указываем Caddy слушать порт 80
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile", "--port", "80"]

EXPOSE 80