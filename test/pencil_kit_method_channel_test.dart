import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pencil_kit/src/pencil_kit_method_channel.dart';

void main() {
  MethodChannelPencilKit platform = MethodChannelPencilKit();
  const MethodChannel channel = MethodChannel('pencil_kit');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
