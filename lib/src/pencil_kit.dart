import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../pencil_kit.dart';

/// Optional callback invoked when a web view is first created. [controller] is
/// the [PencilKitController] for the created pencil kit view.
typedef PencilKitViewCreatedCallback = void Function(PencilKitController controller);

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
    this.onRulerActiveChanged,
    this.isOpaque,
    this.backgroundColor,
    this.onToolPickerVisibilityChanged,
    this.onTapSaveCallback,
    // this.onTapExportCallback,
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

  /// The view’s background color. The default is transparent
  final Color? backgroundColor;

  /// A callback for tool picker visibility state changed
  final void Function(bool isVisible)? onToolPickerVisibilityChanged;

  /// A callback for ruler activate state changed
  final void Function(bool isRulerActive)? onRulerActiveChanged;

  /// A callback for save feature when save button clicked
  final void Function(String? drawingData)? onTapSaveCallback;

  /// A callback for export feature when export button clicked
  // final void Function()? onTapExportCallback;

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
    _controller?._updateWidget(widget, _controller!.viewId);
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
          child: Text('You cannot render PencilKit widget. The platform is not iOS or OS version is lower than 13.0.'),
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
        hitTestBehavior: widget.hitTestBehavior ?? PlatformViewHitTestBehavior.opaque,
      );
    } else {
      return _buildUnAvailable();
    }
  }
}

class PencilKitController {
  PencilKitController._({required this.viewId, required this.widget})
      : _channel = MethodChannel('plugins.mjstudio/flutter_pencil_kit_$viewId') {
    _channel.setMethodCallHandler(
      (MethodCall call) async {
        if (call.method == 'toolPickerVisibilityDidChange') {
          widget.onToolPickerVisibilityChanged?.call(call.arguments as bool);
        }
        if (call.method == 'toolPickerIsRulerActiveDidChange') {
          widget.onRulerActiveChanged?.call(call.arguments as bool);
        }
        if (call.method == 'onTapSaveCallback') {
          widget.onTapSaveCallback?.call(call.arguments as String?);
        }
      },
    );
    _applyProperties();
  }
  final MethodChannel _channel;
  int viewId;
  PencilKit widget;

  void _updateWidget(PencilKit widget, int viewId) {
    this.widget = widget;
    this.viewId = viewId;
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
      'backgroundColor': widget.backgroundColor?.value,
    });
  }

  Future<void> clear() => _channel.invokeMethod('clear');

  Future<void> redo() => _channel.invokeMethod('redo');

  Future<void> undo() => _channel.invokeMethod('undo');

  Future<void> show() => _channel.invokeMethod('show');

  Future<void> hide() => _channel.invokeMethod('hide');

  Future<void> setPKToolPen() => _channel.invokeMethod('setPKToolPen');
  Future<void> setPKToolPencil() => _channel.invokeMethod('setPKToolPencil');
  Future<void> setPKToolMarker() => _channel.invokeMethod('setPKToolMarker');

  /// An eraser that removes an entire drawn line.
  Future<void> setPKToolEraserVector() => _channel.invokeMethod('setPKToolEraserVector');

  /// An eraser that removes only those portions of the drawing it touches.
  Future<void> setPKToolEraserBitmap() => _channel.invokeMethod('setPKToolEraserBitmap');

  Future<void> save() => _channel.invokeMethod('save');

  Future<void> reload(String? drawingData) => _channel.invokeMethod('reload', drawingData);

  Future<String?> export(String? drawingData) => _channel.invokeMethod('export', drawingData);
}
