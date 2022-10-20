import 'package:flutter_test/flutter_test.dart';
import 'package:pencil_kit/pencil_kit.dart';
import 'package:pencil_kit/pencil_kit_platform_interface.dart';
import 'package:pencil_kit/pencil_kit_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPencilKitPlatform
    with MockPlatformInterfaceMixin
    implements PencilKitPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PencilKitPlatform initialPlatform = PencilKitPlatform.instance;

  test('$MethodChannelPencilKit is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPencilKit>());
  });

  test('getPlatformVersion', () async {
    PencilKit pencilKitPlugin = PencilKit();
    MockPencilKitPlatform fakePlatform = MockPencilKitPlatform();
    PencilKitPlatform.instance = fakePlatform;

    expect(await pencilKitPlugin.getPlatformVersion(), '42');
  });
}
