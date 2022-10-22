import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pencil_kit/pencil_kit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final PencilKitController controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PencilKit Example'),
          actions: [
            IconButton(
              icon: const Icon(Icons.palette),
              onPressed: () => controller.show(),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => controller.hide(),
            ),
            IconButton(
              icon: const Icon(Icons.undo),
              onPressed: () => controller.undo(),
            ),
            IconButton(
              icon: const Icon(Icons.redo),
              onPressed: () => controller.redo(),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => controller.clear(),
            ),
          ],
        ),
        body: PencilKit(
          onPencilKitViewCreated: (controller) => this.controller = controller,
          alwaysBounceVertical: false,
          alwaysBounceHorizontal: true,
          isRulerActive: false,
          drawingPolicy: PencilKitIos14DrawingPolicy.anyInput,
          onRulerActiveChanged: (isRulerActive) {
            if (kDebugMode) {
              print('isRulerActive $isRulerActive');
            }
          },
          onToolPickerVisibilityChanged: (isVisible) {
            if (kDebugMode) {
              print('isVisible $isVisible');
            }
          },
          backgroundColor: Colors.blue.withOpacity(0.1),
          isOpaque: false,
        ),
      ),
    );
  }
}
