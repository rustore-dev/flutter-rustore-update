import 'dart:async';

import 'package:flutter_rustore_update/const.dart';
import 'package:flutter_rustore_update/flutter_rustore_update.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    RustoreUpdateClient.debugStateStreamOverride = null;
  });

  test('stateStream shares one broadcast stream across subscribers', () async {
    final controller = StreamController<RequestResponse>.broadcast();
    RustoreUpdateClient.debugStateStreamOverride = controller.stream;

    final receivedByFirst = <RequestResponse>[];
    final receivedBySecond = <RequestResponse>[];

    final firstSubscription =
        RustoreUpdateClient.stateStream.listen(receivedByFirst.add);
    await Future<void>.delayed(Duration.zero);
    final secondSubscription =
        RustoreUpdateClient.stateStream.listen(receivedBySecond.add);
    await Future<void>.delayed(Duration.zero);

    controller.add(
      RequestResponse(
        bytesDownloaded: 25,
        installErrorCode: 0,
        installStatus: INSTALL_STATUS_DOWNLOADING,
        packageName: 'test.package',
        totalBytesToDownload: 100,
      ),
    );

    await Future<void>.delayed(Duration.zero);

    expect(receivedByFirst.single.bytesDownloaded, 25);
    expect(receivedBySecond.single.bytesDownloaded, 25);

    await firstSubscription.cancel();
    await secondSubscription.cancel();

    controller.add(
      RequestResponse(
        bytesDownloaded: 50,
        installErrorCode: 0,
        installStatus: INSTALL_STATUS_DOWNLOADING,
        packageName: 'test.package',
        totalBytesToDownload: 100,
      ),
    );

    await Future<void>.delayed(Duration.zero);
    expect(receivedByFirst, hasLength(1));
    expect(receivedBySecond, hasLength(1));
    await controller.close();
  });

  test('typed mappings expose install status, availability and errors', () {
    final info = UpdateInfo(
      availableVersionCode: 10,
      installStatus: INSTALL_STATUS_PENDING,
      packageName: 'test.package',
      updateAvailability: UPDATE_AVAILABILITY_AVAILABLE,
    );
    final response = RequestResponse(
      bytesDownloaded: 40,
      installErrorCode: UPDATE_ERROR_STORAGE,
      installStatus: INSTALL_STATUS_DOWNLOADING,
      packageName: 'test.package',
      totalBytesToDownload: 80,
    );

    expect(info.installStatusValue, InstallStatus.pending);
    expect(info.updateAvailabilityValue, UpdateAvailability.available);
    expect(response.installStatusValue, InstallStatus.downloading);
    expect(response.installError, RustoreUpdateError.storage);
    expect(response.downloadProgress, 0.5);
  });

  test('legacy listener delegates to stateStream and returns a subscription', () async {
    final controller = StreamController<RequestResponse>.broadcast();
    RustoreUpdateClient.debugStateStreamOverride = controller.stream;
    final received = <RequestResponse>[];

    final subscription = await RustoreUpdateClient.listener(received.add);

    controller.add(
      RequestResponse(
        bytesDownloaded: 10,
        installErrorCode: 0,
        installStatus: INSTALL_STATUS_PENDING,
        packageName: 'test.package',
        totalBytesToDownload: 100,
      ),
    );

    await Future<void>.delayed(Duration.zero);

    expect(received, hasLength(1));
    expect(subscription, isA<StreamSubscription<RequestResponse>>());

    await subscription.cancel();
    await controller.close();
  });
}
