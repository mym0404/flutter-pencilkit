import 'package:flutter/foundation.dart';

import 'pencil_kit_platform_interface.dart';

// ignore: avoid_classes_with_only_static_members
abstract class PencilKitUtil {
  static Future<bool> checkAvailable() async {
    return defaultTargetPlatform == TargetPlatform.iOS &&
        await PencilKitPlatform.instance.checkAvailable();
  }
}
