import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_rustore_update/flutter_rustore_update.dart';
import 'package:flutter_rustore_update/flutter_rustore_update_platform_interface.dart';
import 'package:flutter_rustore_update/flutter_rustore_update_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterRustoreUpdatePlatform
    with MockPlatformInterfaceMixin
    implements FlutterRustoreUpdatePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterRustoreUpdatePlatform initialPlatform = FlutterRustoreUpdatePlatform.instance;

  test('$MethodChannelFlutterRustoreUpdate is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterRustoreUpdate>());
  });

  test('getPlatformVersion', () async {
    FlutterRustoreUpdate flutterRustoreUpdatePlugin = FlutterRustoreUpdate();
    MockFlutterRustoreUpdatePlatform fakePlatform = MockFlutterRustoreUpdatePlatform();
    FlutterRustoreUpdatePlatform.instance = fakePlatform;

    expect(await flutterRustoreUpdatePlugin.getPlatformVersion(), '42');
  });
}
