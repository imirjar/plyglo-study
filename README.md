Платформа курсов Полиглотствуем

This app contains multiple environments.

* Запуск приложения в режиме разрабоки.
Будет работать с тестовыми данными прописанными в lib/data/services/local/mocks
```bash 
$ flutter run --target lib/main_development.dart
```

* Запуск приложения в боевом режиме .
 Будет использовать реальные сервисы, путь к которым указан в 
```bash 
$ flutter run --target lib/main_stage.dart
```


## Тестирование

Integration tests must be run from the `app` directory.

**Integration tests with local data**

```bash
$ flutter test integration_test/app_local_data_test.dart
```
## Описание

Это приложение для изучения иностраннх языков, созданное с использованием Flutter. Оно включает в себя уроки с заданиями разных типов, систему авторизации и сохранение прогресса пользователя.

## Авторизация через Keycloak

Приложение использует OAuth 2.0 Authorization Code Flow with PKCE.

Минимальная настройка Keycloak clients:

- Client type: `OpenID Connect`
- Access type / Client authentication: public client
- Standard flow: enabled
- PKCE: `S256`
- Client `web`:
  - Valid redirect URI: `https://study.plyglo.com/auth/callback`
  - Web origin: `https://study.plyglo.com`
- Client `native`:
  - Valid redirect URI: `com.poliglotim.app:/callback`

Локальный запуск с Keycloak:

```bash
flutter run -d web-server \
  --web-hostname 127.0.0.1 \
  --web-port 8091 \
  --dart-define=API_BASE_URL=https://api.plyglo.com \
  --dart-define=AUTH_BASE_URL=https://auth.plyglo.com \
  --dart-define=KEYCLOAK_REALM=study
```

Если используешь локальный web origin, добавь его в Keycloak client `web`:
`http://127.0.0.1:8091/auth/callback` в Valid redirect URIs и
`http://127.0.0.1:8091` в Web origins.

Для prod-сборки значения по умолчанию уже указывают на публичные сервисы:

```bash
flutter build web --release
```

Если понадобится нестандартный маршрут, можно точечно переопределить
`API_BASE_URL` и `AUTH_BASE_URL`.

## Автор

[Imirjar](https://github.com/imirjar)

Если у вас есть вопросы или предложения, создайте issue в репозитории или свяжитесь со мной.
