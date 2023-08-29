import 'package:flutter_rustore_update/pigeons/rustore.dart';

typedef void Listener(RequestResponse value);

class RustoreUpdateClient {
  static final _api = RustoreUpdate();

  static Future<UpdateInfo> info() async {
    return _api.info();
  }

  static listener(Listener callback) async {
    _api.listener().then((value) {
      // reset callback
      listener(callback);

      callback(value);
    });
  }

  static Future<DownloadResponse> download() async {
    return _api.download();
  }

  static Future<DownloadResponse> immediate() async {
    return _api.immediate();
  }

  static Future<DownloadResponse> silent() async {
    return _api.silent();
  }

  static Future<void> complete() async {
    return _api.complete();
  }
}
