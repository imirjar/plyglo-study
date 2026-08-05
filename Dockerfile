# ---------- Stage 1: Build ----------
FROM ubuntu:24.04 AS builder

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

RUN git clone --depth 1 --branch stable \
    https://github.com/flutter/flutter.git ${FLUTTER_HOME}

RUN flutter config --enable-web

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

RUN flutter build web --release

# ---------- Stage 2: Artifact ----------
FROM ubuntu:24.04

WORKDIR /app

COPY --from=builder /app/build/web /app/build/web

VOLUME ["/app/build/web"]