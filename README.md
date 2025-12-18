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

## Автор

[Imirjar](https://github.com/imirjar)

Если у вас есть вопросы или предложения, создайте issue в репозитории или свяжитесь со мной.
