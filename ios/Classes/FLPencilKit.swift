import Flutter
import UIKit
import PencilKit

class FLPencilKitFactory: NSObject, FlutterPlatformViewFactory{
	private var messenger: FlutterBinaryMessenger
	
	init(messenger: FlutterBinaryMessenger) {
		self.messenger = messenger
		super.init()
	}
	
	func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
		return FlutterStandardMessageCodec.sharedInstance()
	}
	
	func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
		return FLPencilKit(
			frame: frame,
			viewIdentifier: viewId,
			arguments: args,
			binaryMessenger: messenger
		)
	}
}

func debugE(_ msg : Any...){
#if DEBUG
	if msg.count == 0{
		print("🧩",msg,"🧩")
	}else{
		var msgs = ""
		for i in msg{
			msgs += "\(i) "
		}
		print("🧩",msgs,"🧩")
	}
#endif
}
class FLPencilKit: NSObject, FlutterPlatformView {
	private var _view: UIView
	private var _methodChannel: FlutterMethodChannel
	func view() -> UIView { return _view }
	
	init(
		frame: CGRect,
		viewIdentifier viewId: Int64,
		arguments args: Any?,
		binaryMessenger messenger: FlutterBinaryMessenger?
	) {
		if #available(iOS 13.0, *) {
			_view = PencilKitView(frame: frame)
		} else {
			_view = UIView(frame: frame)
		}
		_methodChannel = FlutterMethodChannel(name: "plugins.mjstudio/flutter_pencil_kit_\(viewId)", binaryMessenger: messenger!)
		super.init()
		_methodChannel.setMethodCallHandler(onMethodCall)
	}
	
	
	private func onMethodCall(call: FlutterMethodCall, result: FlutterResult) {
		if #available(iOS 13.0, *) {
			guard let pencilKitView = _view as? PencilKitView else { return }
			switch(call.method){
				case "clear":
					pencilKitView.clear()
				case "redo":
					pencilKitView.redo()
				case "undo":
					pencilKitView.undo()
				case "show":
					pencilKitView.show()
				case "hide":
					pencilKitView.hide()
				default:
					break
			}
		}
	}
}

@available(iOS 13.0, *)
fileprivate class PencilKitView: UIView {
	private lazy var canvasView: PKCanvasView = {
		let v = PKCanvasView()
		v.translatesAutoresizingMaskIntoConstraints = false
		v.delegate = self
		v.drawing = PKDrawing()
		v.alwaysBounceVertical = false
		v.allowsFingerDrawing = true
		v.backgroundColor = .clear
		v.isOpaque = false
		return v
	}()
	
	required init?(coder: NSCoder) {
		fatalError("Not Implemented")
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		if let window = UIApplication.shared.windows.first, let toolPicker = PKToolPicker.shared(for: window){
			toolPicker.addObserver(canvasView)
		}
		
		// layout
		self.addSubview(canvasView)
		NSLayoutConstraint.activate([
			canvasView.widthAnchor.constraint(equalTo: self.widthAnchor),
			canvasView.heightAnchor.constraint(equalTo: self.heightAnchor),
			canvasView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			canvasView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
		])
	}
	
	deinit {
		if let window = UIApplication.shared.windows.first, let toolPicker = PKToolPicker.shared(for: window){
			toolPicker.setVisible(false, forFirstResponder: canvasView)
			toolPicker.removeObserver(canvasView)
		}
	}
	
	func clear(){
		canvasView.drawing = PKDrawing()
	}
	func undo(){
		canvasView.undoManager?.undo()
	}
	func redo(){
		canvasView.undoManager?.redo()
	}
	func show(){
		if let window = UIApplication.shared.windows.first, let toolPicker = PKToolPicker.shared(for: window) {
			toolPicker.setVisible(true, forFirstResponder: canvasView)
		}
		canvasView.becomeFirstResponder()
		canvasView.resignFirstResponder()
		canvasView.becomeFirstResponder()
	}
	func hide(){
		if let window = UIApplication.shared.windows.first, let toolPicker = PKToolPicker.shared(for: window) {
			toolPicker.setVisible(false, forFirstResponder: canvasView)
		}
		canvasView.resignFirstResponder()
	}
}

@available(iOS 13.0, *)
extension PencilKitView: PKCanvasViewDelegate{
	
}

@available(iOS 13.0, *)
extension PencilKitView: PKToolPickerObserver{
	
}
