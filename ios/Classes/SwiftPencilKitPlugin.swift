import Flutter
import UIKit

public class SwiftPencilKitPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
	registrar.register(FLPencilKitFactory(messenger: registrar.messenger()), withId: "plugins.mjstudio/flutter_pencil_kit")
  }
}
