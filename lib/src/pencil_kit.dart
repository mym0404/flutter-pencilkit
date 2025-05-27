import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../pencil_kit.dart';

/// Optional callback invoked when a web view is first created. [controller] is
/// the [PencilKitController] for the created pencil kit view.
typedef PencilKitViewCreatedCallback = void Function(
    PencilKitController controller);

/// PKTool type enum for [PencilKitController.setPKTool]
enum ToolType {
  /// pen tool
  pen(false, false),

  /// pencil tool
  pencil(false, false),

  /// marker tool
  marker(false, false),

  /// monoline tool, available from iOS 17.0
  monoline(false, true),

  /// fountainPen tool, available from iOS 17.0
  fountainPen(false, true),

  /// watercolor tool, available from iOS 17.0
  watercolor(false, true),

  /// crayon tool, available from iOS 17.0
  crayon(false, true),

  /// vector eraser tool
  eraserVector(false, false),

  /// bitmap eraser tool
  eraserBitmap(false, false),

  /// fixed width bitmap eraser tool, available from iOS 16.4
  eraserFixedWidthBitmap(true, false),
  ;

  const ToolType(this.isAvailableFromIos16_4, this.isAvailableFromIos17);

  final bool isAvailableFromIos16_4;
  final bool isAvailableFromIos17;
}

enum PencilKitIos14DrawingPolicy {
  /// if a `PKToolPicker` is visible, respect `UIPencilInteraction.prefersPencilOnlyDrawing`,
  /// otherwise only pencil touches draw.
  defaultInput(0),

  /// if a `PKToolPicker` is visible, respect `UIPencilInteraction.prefersPencilOnlyDrawing`,
  /// otherwise only pencil touches draw.
  anyInput(1),

  /// if a `PKToolPicker` is visible, respect `UIPencilInteraction.prefersPencilOnlyDrawing`,
  /// otherwise only pencil touches draw.
  onlyPencil(2);

  const PencilKitIos14DrawingPolicy(this.value);
  final int value;
}

class PencilKit extends StatefulWidget {
  const PencilKit({
    super.key,
    this.hitTestBehavior,
    this.onPencilKitViewCreated,
    this.unAvailableFallback,
    this.alwaysBounceVertical,
    this.alwaysBounceHorizontal,
    this.isRulerActive,
    this.drawingPolicy,
    this.isOpaque,
    this.isLongPressEnabled,
    this.backgroundColor,
    this.toolPickerVisibilityDidChange,
    this.toolPickerIsRulerActiveDidChange,
    this.toolPickerFramesObscuredDidChange,
    this.toolPickerSelectedToolDidChange,
    this.canvasViewDidBeginUsingTool,
    this.canvasViewDidEndUsingTool,
    this.canvasViewDrawingDidChange,
    this.canvasViewDidFinishRendering,
  });

  /// {@macro flutter.widgets.AndroidView.hitTestBehavior}
  final PlatformViewHitTestBehavior? hitTestBehavior;
  final PencilKitViewCreatedCallback? onPencilKitViewCreated;

  /// A widget for render UnAvailable state. The default is A red box
  final Widget? unAvailableFallback;

  /// A Boolean value that determines whether bouncing always occurs when vertical scrolling reaches the end of the content.
  final bool? alwaysBounceVertical;

  /// A Boolean value that determines whether bouncing always occurs when horizontal scrolling reaches the end of the content view.
  final bool? alwaysBounceHorizontal;

  /// A Boolean value that indicates whether a ruler view is visible on the canvas.
  final bool? isRulerActive;

  /// The policy that controls the types of touches allowed when drawing on the canvas. This properties can be applied from iOS 14.0
  final PencilKitIos14DrawingPolicy? drawingPolicy;

  /// A Boolean value that determines whether the view is opaque.
  ///
  /// This property provides a hint to the drawing system as to how it should treat the view.
  /// If set to true, the drawing system treats the view as fully opaque, which allows the drawing system to optimize some drawing operations and improve performance.
  /// If set to false, the drawing system composites the view normally with other content. The default value of this property is true.
  /// An opaque view is expected to fill its bounds with entirely opaque content—that is, the content should have an alpha value of 1.0.
  /// If the view is opaque and either does not fill its bounds or contains wholly or partially transparent content, the results are unpredictable.
  /// You should always set the value of this property to false if the view is fully or partially transparent.
  final bool? isOpaque;

  /// A Boolean value that indicates whether a long-press with finger touch is enabled.
  final bool? isLongPressEnabled;

  /// The view’s background color. The default is transparent
  final Color? backgroundColor;

  /// Tells the delegate that the tool picker UI changed visibility.
  final void Function(bool isVisible)? toolPickerVisibilityDidChange;

  /// Tells the delegate that the ruler active state was changed by the user.
  final void Function(bool isRulerActive)? toolPickerIsRulerActiveDidChange;

  /// Tells the delegate that the frames the tool picker obscures changed.
  /// Note, the obscured frames for a view can also change when that view
  /// changes, not just when this delegate method is called.
  final void Function()? toolPickerFramesObscuredDidChange;

  /// Tells the delegate that the selected tool was changed by the user.
  final void Function()? toolPickerSelectedToolDidChange;

  /// Called when the user starts using a tool, eg. selecting, drawing, or erasing.
  /// This does not include moving the ruler.
  final void Function()? canvasViewDidBeginUsingTool;

  /// Called when the user stops using a tool, eg. selecting, drawing, or erasing.
  final void Function()? canvasViewDidEndUsingTool;

  /// Called after the drawing on the canvas did change.
  ///
  /// This may be called some time after the `canvasViewDidEndUsingTool:` delegate method.
  /// For example, when using the Apple Pencil, pressure data is delayed from touch data, this
  /// means that the user can stop drawing (`canvasViewDidEndUsingTool:` is called), but the
  /// canvas view is still waiting for final pressure values; only when the final pressure values
  /// are received is the drawing updated and this delegate method called.
  ///
  /// It is also possible that this method is not called, if the drawing interaction is cancelled.
  final void Function()? canvasViewDrawingDidChange;

  /// Called after setting `drawing` when the entire drawing is rendered and visible.
  ///
  /// This method lets you know when the canvas view finishes rendering all of the currently
  /// visible content. This can be used to delay showing the canvas view until all content is visible.
  ///
  /// This is called every time the canvasView transitions from partially rendered to fully rendered,
  /// including after setting the drawing, and after zooming or scrolling.
  final void Function()? canvasViewDidFinishRendering;

  @override
  State<PencilKit> createState() => _PencilKitState();
}

class _PencilKitState extends State<PencilKit> {
  PencilKitController? _controller;

  bool _isAvailableChecked = false;
  bool _isAvailable = false;

  @override
  void initState() {
    super.initState();

    PencilKitUtil.checkAvailable().then((bool available) {
      if (mounted) {
        setState(() {
          _isAvailableChecked = true;
          _isAvailable = available;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant PencilKit oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller?._updateWidget(widget);
  }

  void _onPencilKitPlatformViewCreated(int viewId) {
    _controller = PencilKitController._(widget: widget, viewId: viewId);
    widget.onPencilKitViewCreated?.call(_controller!);
  }

  Widget _buildUnAvailable() =>
      widget.unAvailableFallback ??
      Container(
        color: Colors.red,
        child: const Center(
          child: Text(
              'You cannot render PencilKit widget. The platform is not iOS or OS version is lower than 13.0.'),
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (!_isAvailableChecked) {
      return const SizedBox.shrink();
    }

    if (_isAvailable) {
      return UiKitView(
        viewType: 'plugins.mjstudio/flutter_pencil_kit',
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPencilKitPlatformViewCreated,
        hitTestBehavior:
            widget.hitTestBehavior ?? PlatformViewHitTestBehavior.opaque,
      );
    } else {
      return _buildUnAvailable();
    }
  }
}

class PencilKitController {
  PencilKitController._({required int viewId, required this.widget})
      : _channel =
            MethodChannel('plugins.mjstudio/flutter_pencil_kit_$viewId') {
    _channel.setMethodCallHandler(
      (MethodCall call) async {
        switch (call.method) {
          case 'toolPickerVisibilityDidChange':
            widget.toolPickerVisibilityDidChange?.call(call.arguments as bool);
            break;
          case 'toolPickerIsRulerActiveDidChange':
            widget.toolPickerIsRulerActiveDidChange
                ?.call(call.arguments as bool);
            break;
          case 'toolPickerFramesObscuredDidChange':
            widget.toolPickerFramesObscuredDidChange?.call();
            break;
          case 'toolPickerSelectedToolDidChange':
            widget.toolPickerSelectedToolDidChange?.call();
            break;
          case 'canvasViewDidBeginUsingTool':
            widget.canvasViewDidBeginUsingTool?.call();
            break;
          case 'canvasViewDrawingDidChange':
            widget.canvasViewDrawingDidChange?.call();
            break;
          case 'canvasViewDidEndUsingTool':
            widget.canvasViewDidEndUsingTool?.call();
            break;
          case 'canvasViewDidFinishRendering':
            widget.canvasViewDidFinishRendering?.call();
            break;
          default:
            return;
        }
      },
    );
    _applyProperties();
  }
  final MethodChannel _channel;
  PencilKit widget;

  void _updateWidget(PencilKit widget) {
    this.widget = widget;
    _applyProperties();
  }

  void _applyProperties() {
    // ignore: always_specify_types
    _channel.invokeMethod('applyProperties', {
      'alwaysBounceVertical': widget.alwaysBounceVertical,
      'alwaysBounceHorizontal': widget.alwaysBounceHorizontal,
      'isRulerActive': widget.isRulerActive,
      'drawingPolicy': widget.drawingPolicy?.value,
      'isOpaque': widget.isOpaque,
      'isLongPressEnabled': widget.isLongPressEnabled,
      // ignore: deprecated_member_use
      'backgroundColor': widget.backgroundColor?.value,
    });
  }

  /// Clear all drawing data
  Future<void> clear() => _channel.invokeMethod('clear');

  /// Redo last action on drawing
  Future<void> redo() => _channel.invokeMethod('redo');

  /// Undo last action on drawing
  Future<void> undo() => _channel.invokeMethod('undo');

  /// Show palette
  Future<void> show() => _channel.invokeMethod('show');

  /// Hide palette
  Future<void> hide() => _channel.invokeMethod('hide');

  /// Save drawing data into file system. The absolute uri of file in filesystem should be retrieved other library like 'path_provider'.
  ///
  /// Throws an [Error] if failed
  /// Returns base64 data string if `withBase64Data` is true(default: false) or null.
  ///
  /// Example
  ///
  /// ```dart
  ///  final Directory documentDir = await getApplicationDocumentsDirectory();
  ///  final String pathToSave = '${documentDir.path}/drawing';
  ///  try {
  ///    await controller.save(uri: pathToSave);
  ///    // handle success
  ///  } catch (e) {
  ///    // handle error
  ///  }
  /// ```
  Future<String?> save({required String uri, bool withBase64Data = false}) =>
      _channel.invokeMethod('save', <Object>[uri, withBase64Data]);

  /// Load drawing data from file system. The absolute uri of file in filesystem should be retrieved other library like 'path_provider'.
  ///
  /// Throws an [Error] if failed
  /// Returns base64 data string if `withBase64Data` is true(default: false) or null.
  ///
  /// Example
  ///
  /// ```dart
  ///  final Directory documentDir = await getApplicationDocumentsDirectory();
  ///  final String pathToLoad = '${documentDir.path}/drawing';
  ///  try {
  ///    await controller.load(uri: pathToLoad);
  ///    // handle success
  ///  } catch (e) {
  ///    // handle error
  ///  }
  /// ```
  Future<String?> load({required String uri, bool withBase64Data = false}) =>
      _channel.invokeMethod('load', <Object>[uri, withBase64Data]);

  /// Get current drawing data as base 64 encoded form.
  ///
  /// Throws an [Error] if failed
  /// ```
  Future<String> getBase64Data() async {
    return await _channel.invokeMethod('getBase64Data') as String;
  }

  /// Get current drawing data as png base 64 encoded form.
  ///
  /// Throws an [Error] if failed
  /// ```
  Future<String> getBase64PngData({double scale = 0}) async {
    return await _channel.invokeMethod('getBase64PngData', <Object>[scale])
        as String;
  }

  /// Get current drawing data as jpeg base 64 encoded form.
  ///
  /// Throws an [Error] if failed
  /// ```
  Future<String> getBase64JpegData(
      {double scale = 0, double compression = 0.93}) async {
    return await _channel.invokeMethod('getBase64JpegData', <Object>[
      scale,
      compression,
    ]) as String;
  }

  /// Load drawing data from base 64 encoded form.
  /// ```
  /// Throws an [Error] if failed
  /// ```
  /// Example
  /// ```dart
  /// try {
  ///  await controller.loadBase64Data(base64Data);
  /// // handle success
  /// } catch (e) {
  /// // handle error
  /// }
  /// ```
  Future<void> loadBase64Data(String base64Data) =>
      _channel.invokeMethod('loadBase64Data', base64Data);

  /// Set PKTool toolType, width, and color
  ///
  /// This method can fail if tool type is not supported by device iOS version
  /// In eraser tools, the width parameter works only from iOS 16.4 or above iOS version
  ///
  /// You should check whether feature is available in user's iOS version with [ToolType.isAvailableFromIos16_4] and [ToolType.isAvailableFromIos17]
  ///
  /// See also:
  ///
  /// * [ToolType] available tool types
  Future<void> setPKTool(
          {required ToolType toolType, double? width, Color? color}) =>
      _channel.invokeMethod('setPKTool', <String, Object?>{
        'toolType': toolType.name,
        'width': width,
        // ignore: deprecated_member_use
        'color': color?.value,
      });
}
