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

class FLPencilKit: NSObject, FlutterPlatformView {
	private var _view: UIView
	private var methodChannel: FlutterMethodChannel
	func view() -> UIView { return _view }
	
	init(
		frame: CGRect,
		viewIdentifier viewId: Int64,
		arguments args: Any?,
		binaryMessenger messenger: FlutterBinaryMessenger?
	) {
		methodChannel = FlutterMethodChannel(name: "plugins.mjstudio/flutter_pencil_kit_\(viewId)", binaryMessenger: messenger!)
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
				case "setPKTool":
                    pencilKitView.setPKTool(properties: call.arguments as! [String : Any]);
                case "setPKToolPen":
                    pencilKitView.setPKToolPen()
                case "setPKToolPencil":
                    pencilKitView.setPKToolPencil()
                case "setPKToolMarker":
                    pencilKitView.setPKToolMarker()
                case "setPKToolEraserVector":
                    pencilKitView.setPKToolEraserVector()
                case "setPKToolEraserBitmap":
                    pencilKitView.setPKToolEraserBitmap()
                case "setWidth":
                    pencilKitView.setWidth(width: call.arguments as! Double)
                case "setColor":
                    pencilKitView.setColor(color: call.arguments as! Int)
				case "save":
                pencilKitView.onTapSaveCallback()
                case "reload":
                    pencilKitView.reloadDrawingData(drawingData: call.arguments as! String?)
				case "applyProperties":
					pencilKitView.applyProperties(properties: call.arguments as! [String : Any?]);
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
	private var toolPickerForIos14: PKToolPicker? = nil
	private var toolPicker: PKToolPicker? {
		get {
			if #available(iOS 14.0, *) {
				if toolPickerForIos14 == nil {
					toolPickerForIos14 = PKToolPicker()
				}
				return toolPickerForIos14!
			} else {
				guard let window = UIApplication.shared.windows.first, let toolPicker = PKToolPicker.shared(for: window) else { return nil }
				return toolPicker;
			}
		}
	}
	
	private let channel: FlutterMethodChannel
	
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
		self.addSubview(canvasView)
		NSLayoutConstraint.activate([
			canvasView.widthAnchor.constraint(equalTo: self.widthAnchor),
			canvasView.heightAnchor.constraint(equalTo: self.heightAnchor),
			canvasView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			canvasView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
		])
		
		toolPicker?.addObserver(canvasView)
		toolPicker?.addObserver(self)
		toolPicker?.setVisible(true, forFirstResponder: canvasView)
	}
	
	deinit {
		toolPicker?.removeObserver(canvasView)
		toolPicker?.removeObserver(self)
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
		canvasView.becomeFirstResponder()
	}
	func hide(){
		canvasView.resignFirstResponder()
	}

    func setPKTool(properties: [String:Any]){
	    // toolType
        let inputToolType = properties["toolType"] as! String
        // width value from double to CGFloat
        let inputWidthDouble = properties["width"] as! Double
        let widthFloat = NSNumber.init(value: inputWidthDouble).floatValue
        let widthCGFloat = CGFloat(widthFloat)
        // color value from int to UIColor
        let inputColorInt = properties["color"] as! Int
        let inputUIColor = UIColor(hex: inputColorInt)
        // set PKTool based on input PKToolType
        switch(inputToolType){
            case "pen":
                canvasView.tool = PKInkingTool(.pen, color: inputUIColor, width: widthCGFloat)
            case "pencil":
                canvasView.tool = PKInkingTool(.pencil, color: inputUIColor, width: widthCGFloat)
            case "marker":
                canvasView.tool = PKInkingTool(.marker, color: inputUIColor, width: widthCGFloat)
            case "eraserVector":
                canvasView.tool = PKEraserTool(.vector)
            case "eraserBitmap":
                canvasView.tool = PKEraserTool(.bitmap)
            default:
                break
        }
    }

    func setPKToolPen(){
        canvasView.tool = PKInkingTool(.pen, color: .red, width: 2)
    }
    func setPKToolPencil(){
        canvasView.tool = PKInkingTool(.pencil, color: .gray, width: 3)
    }
    func setPKToolMarker(){
        canvasView.tool = PKInkingTool(.marker, color: .yellow, width: 4)
    }
//    @available(iOS 16.4, *)
    func setPKToolEraserVector(){
        canvasView.tool = PKEraserTool(.vector)
//        canvasView.tool = PKEraserTool(.vector, width: 2)
//        toolPicker?.selectedTool = PKEraserTool(.bitmap, width: 4)
    }
//    @available(iOS 16.4, *)
    func setPKToolEraserBitmap(){
        canvasView.tool = PKEraserTool(.bitmap)
//        canvasView.tool = PKEraserTool(.bitmap, width: 2)
    }
    func setWidth(width: Double) {
        let widthFloat = NSNumber.init(value: width).floatValue
        let widthCGFloat = CGFloat(widthFloat)
//        var currentPKTool = toolPicker?.selectedTool as? PKInkingTool
//        currentPKTool?.width = widthCGFloat
//        print("currentPKTool?.width = ")
//        print(currentPKTool?.width as Any)
        canvasView.tool = PKInkingTool(.pencil, width: widthCGFloat)
    }
    func setColor(color: Int) {
//        var currentPKTool = toolPicker?.selectedTool as? PKInkingTool
//        currentPKTool?.color = UIColor(hex: color)
//        print("currentPKTool?.color = ")
//        print(currentPKTool?.color as Any)
        canvasView.tool = PKInkingTool(.pencil, color: UIColor(hex: color))
    }
    func reloadDrawingData(drawingData: String?) {
       if (drawingData == nil) {
           canvasView.drawing = PKDrawing()
       }
       else{
           do{
               canvasView.drawing = try PKDrawing.init(data: Data(base64Encoded: drawingData!)!)
           }
           catch{
               print("errrrorr")
           }
       }

   }
	func applyProperties(properties: [String:Any?]) {
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
			canvasView.drawingPolicy = PKCanvasViewDrawingPolicy.init(rawValue: UInt(drawingPolicy)) ?? .default
		}
		if let isOpaque = properties["isOpaque"] as? Bool {
			canvasView.isOpaque = isOpaque
		}
		if let backgroundColor = properties["backgroundColor"] as? Int {
			canvasView.backgroundColor = UIColor(hex: backgroundColor)
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
	func toolPickerFramesObscuredDidChange(_ toolPicker: PKToolPicker) {
		
	}
	func toolPickerSelectedToolDidChange(_ toolPicker: PKToolPicker) {
		
	}
	func onTapSaveCallback() {
        channel.invokeMethod("onTapSaveCallback", arguments: canvasView.drawing.dataRepresentation().base64EncodedString())
	}
}

@available(iOS 13.0, *)
extension PencilKitView: PKToolPickerObserver {
	
}

extension UIColor {
	convenience init(hex: Int) {
		let alpha = Double((hex >> 24) & 0xff) / 255
		let red = Double((hex >> 16) & 0xff) / 255
		let green = Double((hex >> 8) & 0xff) / 255
		let blue = Double((hex >> 0) & 0xff) / 255
		
		self.init(red: red, green: green, blue: blue, alpha: alpha)
	}
}
