# flutter_rustore_update

## [Документация RuStore](https://help.rustore.ru/rustore/for_developers/developer-documentation/sdk_updates/flutter)

## Общее

RuStore In-app updates SDK помогает поддерживать актуальную версию вашего приложения на устройстве пользователя.

Когда пользователи поддерживают приложение в актуальном состоянии, они могут опробовать новые функции, а также воспользоваться улучшениями производительности и исправлениями ошибок.

Вы можете использовать RuStore In-app updates SDK для отображения процесса обновления приложения, который обеспечивает фоновую загрузку и установку обновления с контролем состояния. Пользователь сможет использовать ваше приложение в момент загрузки обновления.

### Пример пользовательского сценария

<img src="https://gitflic.ru/project/rustore/flutter-rustore-update/blob/raw?file=flow.png" alt="Update flow" height="400px">

### Условия корректной работы SDK

Для работы RuStore In-app updates SDK необходимо соблюдение следующих условий:

- ОС Android версии 6.0 или выше.
- На устройстве пользователя должен быть установлен RuStore.
- Версия RuStoreApp на устройстве пользователя должна быть актуальной.  
- Приложению RuStore должна быть разрешена установка приложений.

### Пример реализации

Для того, чтобы узнать как правильно интегрировать пакет для работы с push-уведомлениями, рекомендуется ознакомиться с приложением-примером

[https://gitflic.ru/project/rustore/flutter-rustore-update](https://gitflic.ru/project/rustore/flutter-rustore-update)

## Подключение в проект

Для подключения пакета к проекту нужно выполнить команду

```sh
flutter pub add flutter_rustore_update
```

Эта команда добавит строчку в файл pubspec.yaml

```yml
dependencies:
    flutter_rustore_update: ^1.0.0
```

## Проверка наличия обновлений

Прежде чем запрашивать обновление, проверьте, доступно ли обновление для вашего приложения. Для проверки наличия обновлений вызовите метод info(). При вызове данного метода проверяются следующие условия:

- На устройстве пользователя должен быть установлен RuStore.
- Версия RuStoreApp на устройстве пользователя должна быть актуальной.  
- Пользователь и приложение не должны быть заблокированы в RuStore.  

В ответ на данный метод вы получите объект info, который будет содержать в себе информацию о необходимости обновления.

```dart
RustoreUpdateClient.info().then((info) {
    print(info);
}).catchError((err) {
    print(err);
});
```

Объект info содержит набор параметров, необходимых для определения доступности обновления:

* updateAvailability - доступность обновления:
 + UPDATE_AILABILITY_NOT_AVAILABLE - обновление не нужно.
 + UPDATE_AILABILITY_AVAILABLE - обновление требуется загрузить или обновление уже загружено на устройство пользователя.   
 + UPDATE_AILABILITY_IN_PROGRESS - обновление уже скачивается или установка уже запущена.
 + UPDATE_AILABILITY_UNKNOWN - статус по умолчанию.
* installStatus - статус установки обновления, если пользователь уже устанавливает обновление в текущий момент времени:
 + INSTALL_STATUS_DOWNLOADED - скачано.
 + INSTALL_STATUS_DOWNLOADING - скачивается.
 + INSTALL_STATUS_FAILED - ошибка.
 + INSTALL_STATUS_INSTALLING - устанавливается.
 + INSTALL_STATUS_PENDING - в ожидании.
 + INSTALL_STATUS_UNKNOWN - по умолчанию.

Запуск скачивания обновления возможен только в том случае, если поле updateAvailability содержит значение UPDATE_AILABILITY_AVAILABLE.

Метод может вернуть ошибку, детально со списком ошибок можно ознакомиться в разделе ***Возможные ошибки**.

## Скачивание обновления

После подтверждения доступности обновления вы можете запросить у пользователя скачивание обновления, но перед этим необходимо запустить слушатель статуса скачивания обновления, используя метод listener()

```dart
RustoreUpdateClient.listener((value) {
  print("listener installStatus ${value.installStatus}");
  print("listener bytesDownloaded ${value.bytesDownloaded}");
  print("listener totalBytesToDownload ${value.totalBytesToDownload}");
  print("listener installErrorCode ${value.installErrorCode}");
 
  if (value.installStatus == INSTALL_STATUS_DOWNLOADED) {
    // тут можно вызывать метод complete()
  }
});
```

Объект state описывает текущий статус скачивания обновления. Объект содержит:

* installStatus - статус установки обновления, если пользователь уже устанавливает обновление в текущий момент времени:
+ INSTALL_STATUS_DOWNLOADED - скачано. 
+ INSTALL_STATUS_DOWNLOADING - скачивается. 
+ INSTALL_STATUS_FAILED - ошибка. 
+ INSTALL_STATUS_INSTALLING - устанавливается. 
+ INSTALL_STATUS_PENDING - в ожидании. 
+ INSTALL_STATUS_UNKNOWN - по умолчанию. 
* bytesDownloaded - количество загруженных байт. 
* totalBytesToDownload - общее количество байт, которое необходимо скачать. 
* installErrorCode - код ошибки во время скачивания. Детальнее с возможными ошибками можно ознакомиться в разделе **Возможные ошибки**. 

### Скачивание с UI от RuStore

Для запуска скачивания обновления приложения вызовите метод download(). 

```dart
RustoreUpdateClient.download().then((value) {
  print("download code ${value.code}");
}).catchError((err) {
  print("download err ${err}");
});
```

Если пользователь подтвердил скачивание обновления, то value.code = ACTIVITY_RESULT_OK, если отказался, то value.code = ACTIVITY_RESULT_CANCELED.

После вызова метода вы можете следить за статусом скачивания обновления в слушателе. Если в слушателе вы получили статус INSTALL_STATUS_DOWNLOADED, то вы можете вызвать метод установки обновления. Рекомендуем уведомить пользователя о готовности установки обновления. 

Метод может вернуть ошибку. Детальнее со списком ошибок можно ознакомиться в разделе **Возможные ошибки**.

## Установка обновления

После завершения скачивания apk-файла обновления вы можете запустить установку обновления. Для запуска установки обновления вызовите метод complete().

```dart
RustoreUpdateClient.complete().catchError((err) {
  print("complete err ${err}");
});
```

Обновление происходит через нативный инструмент android. В случае успешного обновления приложение закроется. 

На этапе обновления могут возникнуть ошибки. Детальнее с ними можно ознакомиться в разделе **Возможные ошибки**. 

## Возможные ошибки

Если вы получили в ответ onFailure, то не рекомендуем самостоятельно отображать ошибку пользователю. Отображение ошибки может негативно повлиять на пользовательский опыт.

Список возможных ошибок:
* UPDATE_ERROR_DOWNLOAD - Ошибка при скачивании. 
* UPDATE_ERROR_BLOCKED - Установка заблокированна системой.
* UPDATE_ERROR_INVALID_APK - Некорректный APK обновления. 
* UPDATE_ERROR_CONFLICT - Конфликт с текущей версией приложения. 
* UPDATE_ERROR_STORAGE - Недостаточно памяти на устройстве. 
* UPDATE_ERROR_INCOMPATIBLE - Несовместимо с устройством. 
* UPDATE_ERROR_APP_NOT_OWNED - Приложение не куплено. 
* UPDATE_ERROR_INTERNAL_ERROR - Внутренняя ошибка. 
* UPDATE_ERROR_ABORTED - Пользователь отказался от установки обновления. 
* UPDATE_ERROR_APK_NOT_FOUND - apk для запуска установки не найден. 
* UPDATE_ERROR_EXTERNAL_SOURCE_DENIED - Запуск обновления запрещён. Например, в первом методе вернулся ответ о том, что обновление недоступно, но пользователь вызывает второй метод.

