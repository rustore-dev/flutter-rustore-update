import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rustore_update/pigeons/rustore.dart';

export 'package:flutter_rustore_update/const.dart';
export 'package:flutter_rustore_update/pigeons/rustore.dart'
    show DownloadResponse, RequestResponse, UpdateInfo;
export 'package:flutter_rustore_update/src/rustore_update_types.dart';

typedef void Listener(RequestResponse value);

class RustoreUpdateClient {
  static final _api = RustoreUpdate();
  static const EventChannel _stateEventChannel = EventChannel(
    'ru.rustore.flutter_rustore_update/state',
  );
  static Stream<RequestResponse>? _stateStream;

  @visibleForTesting
  static Stream<RequestResponse>? debugStateStreamOverride;

  static Future<UpdateInfo> info() async {
    return _api.info();
  }

  static Stream<RequestResponse> get stateStream {
    final debugStream = debugStateStreamOverride;
    if (debugStream != null) {
      return debugStream;
    }

    return _stateStream ??= _stateEventChannel
        .receiveBroadcastStream()
        .map((event) => RequestResponse.decode(event!))
        .asBroadcastStream();
  }

  @Deprecated('Use RustoreUpdateClient.stateStream.listen(callback) instead.')
  static Future<StreamSubscription<RequestResponse>> listener(
    Listener callback,
  ) async {
    return stateStream.listen(callback);
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

  static Future<void> completeUpdateSilent() async {
    return _api.completeUpdateSilent();
  }

  static Future<void> completeUpdateFlexible() async {
    return _api.completeUpdateFlexible();
  }
}
