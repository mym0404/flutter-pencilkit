import Flutter
import UIKit

public class SwiftPencilKitPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    registrar.register(
      FLPencilKitFactory(messenger: registrar.messenger()),
      withId: "plugins.mjstudio/flutter_pencil_kit"
    )

    let channel = FlutterMethodChannel(
      name: "plugins.mjstudio/flutter_pencil_kit/util",
      binaryMessenger: registrar.messenger()
    )

    channel.setMethodCallHandler {
      (call: FlutterMethodCall, result: @escaping FlutterResult) in
      PencilKitUtil.handleMethodCall(call: call, result: result)
    }
  }
}

private enum PencilKitUtil {
  static func handleMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "checkAvailable" {
      result(ProcessInfo().operatingSystemVersion.majorVersion >= 13)
    }
  }
}
