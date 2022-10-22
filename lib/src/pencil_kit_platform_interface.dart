import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'pencil_kit_method_channel.dart';

abstract class PencilKitPlatform extends PlatformInterface {
  PencilKitPlatform() : super(token: _token);

  static final Object _token = Object();

  static PencilKitPlatform _instance = MethodChannelPencilKit();

  static PencilKitPlatform get instance => _instance;

  static set instance(PencilKitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> checkAvailable();
}
