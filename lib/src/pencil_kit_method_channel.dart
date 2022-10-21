import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'pencil_kit_platform_interface.dart';

/// An implementation of [PencilKitPlatform] that uses method channels.
class MethodChannelPencilKit extends PencilKitPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pencil_kit');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
