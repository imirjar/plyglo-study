FROM ubuntu:latest AS build

ENV DEBIAN_FRONTEND=noninteractive
ENV FLUTTER_HOME=/opt/flutter
ENV PATH="${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin:${PATH}"

# Только минимальные зависимости для Flutter Web
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Устанавливаем Flutter
RUN git clone --depth 1 --branch stable \
    https://github.com/flutter/flutter.git ${FLUTTER_HOME}

# Включаем Web поддержку
RUN flutter config --enable-web

WORKDIR /app
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get
COPY . .
RUN flutter build web --release

FROM caddy:alpine
COPY --from=build /app/build/web /srv
COPY Caddyfile /etc/caddy/Caddyfile

# Caddy в alpine слушает порт 8080 по умолчанию
EXPOSE 80