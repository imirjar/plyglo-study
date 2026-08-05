FROM ghcr.io/gmeligio/flutter-web:3.44.8 AS builder

WORKDIR /app

COPY . .

RUN flutter pub get
RUN flutter build web --release

VOLUME /app/build/web