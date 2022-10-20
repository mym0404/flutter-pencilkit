import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'pencil_kit_method_channel.dart';

abstract class PencilKitPlatform extends PlatformInterface {
  /// Constructs a PencilKitPlatform.
  PencilKitPlatform() : super(token: _token);

  static final Object _token = Object();

  static PencilKitPlatform _instance = MethodChannelPencilKit();

  /// The default instance of [PencilKitPlatform] to use.
  ///
  /// Defaults to [MethodChannelPencilKit].
  static PencilKitPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PencilKitPlatform] when
  /// they register themselves.
  static set instance(PencilKitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
