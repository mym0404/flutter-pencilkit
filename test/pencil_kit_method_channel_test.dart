import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pencil_kit/src/pencil_kit_method_channel.dart';

void main() {
  final MethodChannelPencilKit platform = MethodChannelPencilKit();
  const MethodChannel channel = MethodChannel('plugins.mjstudio/flutter_pencil_kit/util');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return true;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('checkAvailable', () async {
    expect(await platform.checkAvailable(), true);
  });
}
