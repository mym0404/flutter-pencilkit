import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../pencil_kit.dart';

/// Optional callback invoked when a web view is first created. [controller] is
/// the [PencilKitController] for the created pencil kit view.
typedef PencilKitViewCreatedCallback = void Function(PencilKitController controller);

class PencilKit extends StatefulWidget {
  const PencilKit({
    super.key,
    this.hitTestBehavior,
    this.onPencilKitViewCreated,
    this.unAvailableFallback,
  });

  final PlatformViewHitTestBehavior? hitTestBehavior;
  final PencilKitViewCreatedCallback? onPencilKitViewCreated;
  final Widget? unAvailableFallback;

  @override
  State<PencilKit> createState() => _PencilKitState();
}

class _PencilKitState extends State<PencilKit> {
  late final PencilKitController _controller;

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
    _controller._updateWidget(widget);
  }

  void _onPencilKitPlatformViewCreated(int viewId) {
    _controller = PencilKitController._(widget: widget, viewId: viewId);
    widget.onPencilKitViewCreated?.call(_controller);
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
        hitTestBehavior: widget.hitTestBehavior ?? PlatformViewHitTestBehavior.opaque,
      );
    } else {
      return _buildUnAvailable();
    }
  }
}

class PencilKitController {
  PencilKitController._({required int viewId, required this.widget})
      : _channel = MethodChannel('plugins.mjstudio/flutter_pencil_kit_$viewId');
  final MethodChannel _channel;
  PencilKit widget;

  void _updateWidget(PencilKit widget) => this.widget = widget;

  Future<void> clear() => _channel.invokeMethod('clear');

  Future<void> redo() => _channel.invokeMethod('redo');

  Future<void> undo() => _channel.invokeMethod('undo');

  Future<void> show() => _channel.invokeMethod('show');

  Future<void> hide() => _channel.invokeMethod('hide');
}
