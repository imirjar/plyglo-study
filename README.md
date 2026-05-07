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

Минимальная настройка Keycloak client:

- Client type: `OpenID Connect`
- Access type / Client authentication: public client
- Standard flow: enabled
- Valid redirect URIs для web: `http://127.0.0.1:8091/auth/callback`
- Web origins для web: `http://127.0.0.1:8091`
- Redirect URI для mobile/desktop: `com.poliglotim.app:/callback`

Локальный запуск с Keycloak:

```bash
flutter run -d web-server \
  --web-hostname 127.0.0.1 \
  --web-port 8091 \
  --dart-define=KEYCLOAK_BASE_URL=http://localhost/api \
  --dart-define=KEYCLOAK_REALM=study \
  --dart-define=KEYCLOAK_CLIENT_ID=frontend \
  --dart-define=COURSES_BASE_URL=http://localhost/api
```

Если используешь другой realm/client, поменяй значения `KEYCLOAK_REALM` и
`KEYCLOAK_CLIENT_ID`.

## Автор

[Imirjar](https://github.com/imirjar)

Если у вас есть вопросы или предложения, создайте issue в репозитории или свяжитесь со мной.
