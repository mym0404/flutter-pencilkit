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
      home: SafeArea(
        child: Scaffold(
            body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                alignment: Alignment.center,
                color: Colors.green.withOpacity(0.25),
                width: MediaQuery.of(context).size.width,
                height: 42,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'PencilKit Example',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.palette,
                            color: Colors.black,
                          ),
                          onPressed: () => controller.show(),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                          onPressed: () => controller.hide(),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.undo,
                            color: Colors.black,
                          ),
                          onPressed: () => controller.undo(),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.redo,
                            color: Colors.black,
                          ),
                          onPressed: () => controller.redo(),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.refresh,
                            color: Colors.black,
                          ),
                          onPressed: () => controller.clear(),
                        ),
                      ],
                    ),
                    // add buttons for new feature - save, export
                    Row(
                      children: [
                        // save button
                        IconButton(
                          icon: const Icon(
                            Icons.save,
                            color: Colors.black,
                          ),
                          onPressed: () => controller.clear(),
                        ),
                        // export button
                        IconButton(
                          icon: const Icon(
                            Icons.download,
                            color: Colors.black,
                          ),
                          onPressed: () => controller.clear(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PencilKit(
                  onPencilKitViewCreated: (controller) => this.controller = controller,
                  alwaysBounceVertical: false,
                  alwaysBounceHorizontal: true,
                  isRulerActive: false,
                  drawingPolicy: PencilKitIos14DrawingPolicy.anyInput,
                  onToolPickerVisibilityChanged: (isVisible) {
                    if (kDebugMode) {
                      print('isToolPickerVisible $isVisible');
                    }
                  },
                  onRulerActiveChanged: (isRulerActive) {
                    if (kDebugMode) {
                      print('isRulerActive $isRulerActive');
                    }
                  },
                  backgroundColor: Colors.white,
                  isOpaque: false,
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
