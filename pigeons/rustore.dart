import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
    dartOut: 'lib/pigeons/rustore.dart',
    dartOptions: DartOptions(),
    javaOut:
        'android/src/main/kotlin/ru/rustore/flutter_rustore_update/pigeons/Rustore.java',
    javaOptions: JavaOptions(
        package: 'ru.rustore.flutter_rustore_update.pigeons')))

class UpdateInfo {
  late int availableVersionCode;
  late int installStatus;
  late String packageName;
  late int updateAvailability;
}

class RequestResponse {
  late int bytesDownloaded;
  late int installErrorCode;
  late int installStatus;
  late String packageName;
  late int totalBytesToDownload;
}

class DownloadResponse {
  late int code;
}

@HostApi()
abstract class RustoreUpdate {
  @async
  UpdateInfo info();

  @async
  RequestResponse listener();

  @async
  DownloadResponse immediate();

  @async
  DownloadResponse silent();

  @async
  DownloadResponse download();

  @async
  void completeUpdateSilent();

  @async
  void completeUpdateFlexible();
}
