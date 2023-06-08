import 'package:pigeon/pigeon.dart';

class UpdateInfo {
  late int availableVersionCode;
  late int installStatus;
  late String packageName;
  late int updateAvailability;
}

class RequestResponse {
  late String status;
}

class DownloadResponse {
  late int code;
}

@HostApi()
abstract class RustoreUpdate {
  @async
  UpdateInfo info();

  @async
  RequestResponse request();

  @async
  DownloadResponse download();

  @async
  void complete();
}
