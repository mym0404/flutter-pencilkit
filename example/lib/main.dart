import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
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
        body: Column(
          children: [
            SingleChildScrollView(
                child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () async {
                    final Directory documentDir = await getApplicationDocumentsDirectory();
                    final String pathToSave = '${documentDir.path}/drawing';
                    try {
                      await controller.save(uri: pathToSave);
                      Fluttertoast.showToast(
                          msg: "Save Success to [$pathToSave]",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.blueAccent,
                          textColor: Colors.white,
                          fontSize: 12.0);
                    } catch (e) {
                      Fluttertoast.showToast(
                          msg: "Save Failed to [$pathToSave]",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          fontSize: 12.0);
                    }
                  },
                  tooltip: "Save",
                ),
                IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () async {
                    final Directory documentDir = await getApplicationDocumentsDirectory();
                    final String pathToLoad = '${documentDir.path}/drawing';
                    try {
                      await controller.load(uri: pathToLoad);
                      Fluttertoast.showToast(
                          msg: "Load Success from [$pathToLoad]",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.blueAccent,
                          textColor: Colors.white,
                          fontSize: 12.0);
                    } catch (e) {
                      Fluttertoast.showToast(
                          msg: "Load Failed from [$pathToLoad]",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          fontSize: 12.0);
                    }
                  },
                  tooltip: "Load",
                ),
              ],
            )),
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
                backgroundColor: Colors.blue.withOpacity(0.1),
                isOpaque: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
