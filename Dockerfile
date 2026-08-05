FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV FLUTTER_HOME=/opt/flutter
ENV PATH="${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin:${PATH}"

RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    xz-utils \
    zip \
    ca-certificates \
    clang \
    cmake \
    ninja-build \
    pkg-config \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Установка Flutter
RUN git clone --depth 1 --branch stable https://github.com/flutter/flutter.git ${FLUTTER_HOME}

# Первичная инициализация
RUN flutter doctor
RUN flutter config --enable-web

WORKDIR /app

# Сначала зависимости (для кэширования)
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Затем проект
COPY . .

# Сборка web
RUN flutter build web --release

# Здесь будет готовый билд
VOLUME ["/app/build/web"]