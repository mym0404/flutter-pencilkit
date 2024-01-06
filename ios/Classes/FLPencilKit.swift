import Flutter
import PencilKit
import UIKit

class FLPencilKitFactory: NSObject, FlutterPlatformViewFactory {
  private var messenger: FlutterBinaryMessenger

  init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger
    super.init()
  }

  func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    FlutterStandardMessageCodec.sharedInstance()
  }

  func create(
    withFrame frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> FlutterPlatformView {
    FLPencilKit(
      frame: frame,
      viewIdentifier: viewId,
      arguments: args,
      binaryMessenger: messenger
    )
  }
}

enum FLPencilKitError: Error {
  case invalidArgument
}

class FLPencilKit: NSObject, FlutterPlatformView {
  private var _view: UIView
  private var methodChannel: FlutterMethodChannel
  func view() -> UIView { _view }

  init(
    frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?,
    binaryMessenger messenger: FlutterBinaryMessenger?
  ) {
    methodChannel = FlutterMethodChannel(
      name: "plugins.mjstudio/flutter_pencil_kit_\(viewId)",
      binaryMessenger: messenger!
    )
    if #available(iOS 13.0, *) {
      _view = PencilKitView(frame: frame, methodChannel: methodChannel)
    } else {
      _view = UIView(frame: frame)
    }
    super.init()
    methodChannel.setMethodCallHandler(onMethodCall)
  }

  private func onMethodCall(call: FlutterMethodCall, result: FlutterResult) {
    if #available(iOS 13.0, *) {
      guard let pencilKitView = _view as? PencilKitView else { return }
      switch call.method {
      case "clear":
        pencilKitView.clear()
        result(nil)
      case "redo":
        pencilKitView.redo()
        result(nil)
      case "undo":
        pencilKitView.undo()
        result(nil)
      case "show":
        pencilKitView.show()
        result(nil)
      case "hide":
        pencilKitView.hide()
        result(nil)
      case "save":
        save(pencilKitView: pencilKitView, call: call, result: result)
      case "load":
        load(pencilKitView: pencilKitView, call: call, result: result)
      case "getBase64Data":
        getBase64Data(pencilKitView: pencilKitView, call: call, result: result)
      case "loadBase64Data":
        loadBase64Data(pencilKitView: pencilKitView, call: call, result: result)
      case "applyProperties":
        pencilKitView.applyProperties(properties: call.arguments as! [String: Any?])
        result(nil)
      default:
        break
      }
    }
  }

  @available(iOS 13, *)
  private func save(pencilKitView: PencilKitView, call: FlutterMethodCall, result: FlutterResult) {
    do {
      let (url, withBase64Data) = parseArguments(call.arguments)
      let base64Data = try pencilKitView.save(url: url, withBase64Data: withBase64Data)
      result(base64Data)
    } catch {
      result(FlutterError(code: "NATIVE_ERROR", message: error.localizedDescription, details: nil))
    }
  }

  @available(iOS 13, *)
  private func load(pencilKitView: PencilKitView, call: FlutterMethodCall, result: FlutterResult) {
    do {
      let (url, withBase64Data) = parseArguments(call.arguments)
      let base64Data = try pencilKitView.load(url: url, withBase64Data: withBase64Data)
      result(base64Data)
    } catch {
      result(FlutterError(code: "NATIVE_ERROR", message: error.localizedDescription, details: nil))
    }
  }

  @available(iOS 13, *)
  private func getBase64Data(
    pencilKitView: PencilKitView,
    call: FlutterMethodCall,
    result: FlutterResult
  ) {
    let base64Data = pencilKitView.getBase64Data()
    result(base64Data)
  }

  @available(iOS 13, *)
  private func loadBase64Data(
    pencilKitView: PencilKitView,
    call: FlutterMethodCall,
    result: FlutterResult
  ) {
    do {
      let (base64Data) = parseArguments(call.arguments)
      try pencilKitView.loadBase64Data(base64Data: base64Data)
      result(nil)
    } catch {
      result(FlutterError(code: "NATIVE_ERROR", message: error.localizedDescription, details: nil))
    }
  }

  private func parseArguments(_ arguments: Any?) -> (URL, Bool) {
    guard let arguments = arguments as? [Any] else { fatalError() }
    return (URL(fileURLWithPath: arguments[0] as! String), arguments[1] as! Bool)
  }
}

@available(iOS 13.0, *)
private func createCanvasView(delegate: PKCanvasViewDelegate) -> PKCanvasView {
  let v = PKCanvasView()
  v.translatesAutoresizingMaskIntoConstraints = false
  v.drawing = PKDrawing()
  v.delegate = delegate
  v.alwaysBounceVertical = false
  v.allowsFingerDrawing = true
  v.backgroundColor = .clear
  v.isOpaque = false
  return v
}

@available(iOS 13.0, *)
private class PencilKitView: UIView {
  private lazy var canvasView: PKCanvasView = createCanvasView(delegate: self)

  private var toolPickerForIos14: PKToolPicker? = nil
  private var toolPicker: PKToolPicker? {
    if #available(iOS 14.0, *) {
      if toolPickerForIos14 == nil {
        toolPickerForIos14 = PKToolPicker()
      }
      return toolPickerForIos14!
    } else {
      guard let window = UIApplication.shared.windows.first,
            let toolPicker = PKToolPicker.shared(for: window) else { return nil }
      return toolPicker
    }
  }

  private let channel: FlutterMethodChannel

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("Not Implemented")
  }

  override init(frame: CGRect) {
    fatalError("Not Implemented")
  }

  init(frame: CGRect, methodChannel: FlutterMethodChannel) {
    channel = methodChannel
    super.init(frame: frame)

    // layout
    layoutCanvasView()

    toolPicker?.addObserver(canvasView)
    toolPicker?.addObserver(self)
    toolPicker?.setVisible(true, forFirstResponder: canvasView)
  }

  private func layoutCanvasView() {
    addSubview(canvasView)
    NSLayoutConstraint.activate([
      canvasView.widthAnchor.constraint(equalTo: widthAnchor),
      canvasView.heightAnchor.constraint(equalTo: heightAnchor),
      canvasView.centerXAnchor.constraint(equalTo: centerXAnchor),
      canvasView.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }

  deinit {
    toolPicker?.removeObserver(canvasView)
    toolPicker?.removeObserver(self)
  }

  func clear() {
    canvasView.drawing = PKDrawing()
  }

  func undo() {
    canvasView.undoManager?.undo()
  }

  func redo() {
    canvasView.undoManager?.redo()
  }

  func show() {
    canvasView.becomeFirstResponder()
  }

  func hide() {
    canvasView.resignFirstResponder()
  }

  func save(url: URL, withBase64Data: Bool) throws -> String? {
    let data = canvasView.drawing.dataRepresentation()
    try data.write(to: url)
    if withBase64Data {
      return data.base64EncodedString()
    }
    return nil
  }

  func load(url: URL, withBase64Data: Bool) throws -> String? {
    let data = try Data(contentsOf: url)
    let drawing = try PKDrawing(data: data)

    let newCanvasView = createCanvasView(delegate: self)
    newCanvasView.drawing = drawing
    canvasView.removeFromSuperview()
    synchronizeCanvasViewProperties(old: canvasView, new: newCanvasView)
    canvasView = newCanvasView
    layoutCanvasView()

    if withBase64Data {
      return drawing.dataRepresentation().base64EncodedString()
    }
    return nil
  }

  func getBase64Data() -> String {
    canvasView.drawing.dataRepresentation().base64EncodedString()
  }

  func loadBase64Data(base64Data: String) throws {
    let data = Data(base64Encoded: base64Data)!
    let drawing = try PKDrawing(data: data)

    let newCanvasView = createCanvasView(delegate: self)
    newCanvasView.drawing = drawing
    canvasView.removeFromSuperview()
    synchronizeCanvasViewProperties(old: canvasView, new: newCanvasView)
    canvasView = newCanvasView
    layoutCanvasView()
  }

  func applyProperties(properties: [String: Any?]) {
    if let alwaysBounceVertical = properties["alwaysBounceVertical"] as? Bool {
      canvasView.alwaysBounceVertical = alwaysBounceVertical
    }
    if let alwaysBounceHorizontal = properties["alwaysBounceHorizontal"] as? Bool {
      canvasView.alwaysBounceHorizontal = alwaysBounceHorizontal
    }
    if let isRulerActive = properties["isRulerActive"] as? Bool {
      canvasView.isRulerActive = isRulerActive
    }
    if #available(iOS 14.0, *), let drawingPolicy = properties["drawingPolicy"] as? Int {
      canvasView
        .drawingPolicy = PKCanvasViewDrawingPolicy(rawValue: UInt(drawingPolicy)) ?? .default
    }
    if let isOpaque = properties["isOpaque"] as? Bool {
      canvasView.isOpaque = isOpaque
    }
    if let backgroundColor = properties["backgroundColor"] as? Int {
      canvasView.backgroundColor = UIColor(hex: backgroundColor)
    }
  }

  private func synchronizeCanvasViewProperties(old: PKCanvasView, new: PKCanvasView) {
    if let toolPicker {
      toolPicker.removeObserver(old)
      toolPicker.addObserver(new)
      toolPicker.setVisible(true, forFirstResponder: new)
    }

    new.alwaysBounceVertical = old.alwaysBounceVertical
    new.alwaysBounceHorizontal = old.alwaysBounceHorizontal
    new.isRulerActive = old.isRulerActive
    if #available(iOS 14.0, *) {
      new.drawingPolicy = old.drawingPolicy
    }
    new.isOpaque = old.isOpaque
    new.backgroundColor = old.backgroundColor

    if toolPicker?.isVisible == true {
      new.becomeFirstResponder()
    }
  }
}

@available(iOS 13.0, *)
extension PencilKitView: PKCanvasViewDelegate {
  func toolPickerIsRulerActiveDidChange(_ toolPicker: PKToolPicker) {
    channel.invokeMethod("toolPickerIsRulerActiveDidChange", arguments: toolPicker.isRulerActive)
  }

  func toolPickerVisibilityDidChange(_ toolPicker: PKToolPicker) {
    channel.invokeMethod("toolPickerVisibilityDidChange", arguments: toolPicker.isVisible)
  }

  func toolPickerFramesObscuredDidChange(_ toolPicker: PKToolPicker) {}

  func toolPickerSelectedToolDidChange(_ toolPicker: PKToolPicker) {}
}

@available(iOS 13.0, *)
extension PencilKitView: PKToolPickerObserver {}

extension UIColor {
  convenience init(hex: Int) {
    let alpha = Double((hex >> 24) & 0xFF) / 255
    let red = Double((hex >> 16) & 0xFF) / 255
    let green = Double((hex >> 8) & 0xFF) / 255
    let blue = Double((hex >> 0) & 0xFF) / 255

    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}
