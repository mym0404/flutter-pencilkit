import 'package:flutter/services.dart';

import 'pencil_kit_platform_interface.dart';

class MethodChannelPencilKit extends PencilKitPlatform {
  final MethodChannel _channel =
      const MethodChannel('plugins.mjstudio/flutter_pencil_kit/util');

  @override
  Future<bool> checkAvailable() async {
    return await _channel.invokeMethod('checkAvailable') as bool;
  }
}
