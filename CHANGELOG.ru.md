<!-- ── Language switch (RU active) ──────────────────────────────────── -->

<div align="left" style="margin:0 0 14px 0;">

<span style="display:inline-block;
padding:.28rem .6rem;
border:1px solid rgba(0,0,0,.18);
border-radius:10px 0 0 10px;
font-weight:400;
font-size:12px;
letter-spacing:.06em;
color:#111827;
background:linear-gradient(180deg,#e9edf2,#ffffff);
box-shadow:inset 0 2px 6px rgba(0,0,0,.10);">
RU
</span><span style="display:inline-block;
margin-left:-1px;
padding:.28rem .6rem;
border:1px solid rgba(0,0,0,.14);
border-radius:0 10px 10px 0;
font-weight:400;
font-size:12px;
letter-spacing:.06em;
background:linear-gradient(180deg,#ffffff,#f3f4f6);
box-shadow:0 1px 0 rgba(0,0,0,.06);">
[EN]
</span>

</div>
<!-- ────────────────────────────────────────────────────────────────── -->

## 10.5.2

- Изменено: ссылка на maven-репозиторий

## 10.5.1

- Изменено: поддержано RuStore appupdate SDK 10.5.1

## 10.5.0

- Изменено: поддержано RuStore appupdate SDK 10.5.0
- Исправлено: ошибки совместимости после обновления Pigeon до 22.5.0

## 10.4.0

- Релиз пропущен

## 10.3.1

* Обновление RuStore AppUpdate SDK до версии 10.3.1
* Обновление инструментов Flutter: Dart ≥3.3.0, flutter_lints 4.0, pigeon 22.5, minSdkVersion 24

## 10.3.0

* Поднята версия RuStore Update SDK до 10.3.0.

## 10.2.0

* Поднята версия RuStore Update SDK до 10.2.0.
* Добавлен новый `RustoreUpdateClient.stateStream` для отслеживания статуса обновления через `Stream`.
* Доставка событий переведена на native `EventChannel` вместо бесконечного Dart polling.
* На Android listener теперь корректно регистрируется через `registerListener(...)` и снимается через `unregisterListener(...)` при `cancel/dispose`.
* Сохранена обратная совместимость для legacy API: `RustoreUpdateClient.listener(...)` оставлен как обёртка над `stateStream.listen(...)`.
* Сохранена нативная обратная совместимость для legacy one-shot пути `listener()`.
* Добавлены type-safe enum-обёртки `InstallStatus`, `UpdateAvailability`, `RustoreUpdateError`.
* Добавлены удобные геттеры `installStatusValue`, `updateAvailabilityValue`, `installError`, `downloadProgress`.
* Добавлены корректно написанные алиасы `UPDATE_AVAILABILITY_*` без удаления старых `UPDATE_AILABILITY_*`.
* Обновлены пример приложения, README и тесты для использования lifecycle-safe подписок и читаемых статусов.

## 10.1.0

* Обновление RuStore Update SDK до версии 10.1.0

## 10.0.0

* Обновление RuStore Update SDK до версии 10.0.0

## 9.1.0

* Обновление RuStore Update SDK до версии 9.1.0

## 9.0.2

* Обновление RuStore Update SDK до версии 9.0.2

## 9.0.1

* Обновление RuStore Update SDK до версии 9.0.1

## 8.0.0

* Обновление RuStore Update SDK до версии 8.0.0

## 7.0.1

* Добавлена поддержка gradle 8

## 7.0.0

* Обновление RuStore Update SDK до версии 7.0.0

## 6.1.0

* Обновление RuStore Update SDK до версии 6.1.0

## 6.0.0

* Обновление RuStore Update SDK до версии 6.0.0

## 3.0.0

* Обновление RuStore Update SDK до версии 3.0.0

## 2.0.0

* Обновление RuStore Update SDK до версии 2.0.0

## 1.0.0

* Обновление RuStore Update SDK до версии 1.0.0

## 0.0.3

* Обновление RuStore Update SDK до версии 0.2.0

## 0.0.2

* Обновлены readme и документация

## 0.0.1

* Полная поддержка RuStore Update SDK

[en]: CHANGELOG.md
