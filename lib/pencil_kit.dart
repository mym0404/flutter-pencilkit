
import 'pencil_kit_platform_interface.dart';

class PencilKit {
  Future<String?> getPlatformVersion() {
    return PencilKitPlatform.instance.getPlatformVersion();
  }
}
