import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pencil_kit/pencil_kit.dart';

void main() {
  runApp(const MyApp());
}

enum ToolType {
  pen,
  pencil,
  marker,
  eraserVector,
  eraserBitmap,
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final PencilKitController controller;
  String currentToolType = ToolType.pen.name;
  double currentWidth = 1;
  Color currentColor = Colors.black;

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
                    final Directory documentDir =
                        await getApplicationDocumentsDirectory();
                    final String pathToSave = '${documentDir.path}/drawing';
                    try {
                      final data = await controller.save(
                          uri: pathToSave, withBase64Data: true);
                      if (kDebugMode) {
                        print(data);
                      }
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
                    final Directory documentDir =
                        await getApplicationDocumentsDirectory();
                    final String pathToLoad = '${documentDir.path}/drawing';
                    try {
                      final data = await controller.load(
                          uri: pathToLoad, withBase64Data: true);
                      if (kDebugMode) {
                        print(data);
                      }
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
                IconButton(
                  icon: const Icon(Icons.print),
                  onPressed: () async {
                    final data = await controller.getBase64Data();
                    Fluttertoast.showToast(
                        msg: data,
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blueAccent,
                        textColor: Colors.white,
                        fontSize: 12.0);
                  },
                  tooltip: "Get base64 data",
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.lens,
                    color: Colors.orange,
                  ),
                  onPressed: () {
                    setState(() {
                      currentColor = Colors.orange;
                      controller.setPKTool(
                        toolType: currentToolType,
                        width: currentWidth,
                        color: currentColor,
                      );
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.lens,
                    color: Colors.purpleAccent,
                  ),
                  onPressed: () {
                    setState(() {
                      currentColor = Colors.purpleAccent;
                      controller.setPKTool(
                        toolType: currentToolType,
                        width: currentWidth,
                        color: currentColor,
                      );
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.lens,
                    color: Colors.greenAccent,
                  ),
                  onPressed: () {
                    setState(() {
                      currentColor = Colors.greenAccent;
                      controller.setPKTool(
                        toolType: currentToolType,
                        width: currentWidth,
                        color: currentColor,
                      );
                    });
                  },
                ),
                IconButton(
                  icon: Container(
                    color: Colors.black,
                    width: 12,
                    height: 1,
                  ),
                  onPressed: () {
                    setState(() {
                      currentWidth = 1;
                      controller.setPKTool(
                        toolType: currentToolType,
                        width: currentWidth,
                        color: currentColor,
                      );
                    });
                  },
                ),
                IconButton(
                  icon: Container(
                    color: Colors.black,
                    width: 12,
                    height: 3,
                  ),
                  onPressed: () {
                    setState(() {
                      currentWidth = 3;
                      controller.setPKTool(
                        toolType: currentToolType,
                        width: currentWidth,
                        color: currentColor,
                      );
                    });
                  },
                ),
                IconButton(
                  icon: Container(
                    color: Colors.black,
                    width: 12,
                    height: 5,
                  ),
                  onPressed: () {
                    setState(() {
                      currentWidth = 5;
                      controller.setPKTool(
                        toolType: currentToolType,
                        width: currentWidth,
                        color: currentColor,
                      );
                    });
                  },
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      currentToolType = ToolType.pen.name;
                      controller.setPKTool(
                        toolType: currentToolType,
                        width: currentWidth,
                        color: currentColor,
                      );
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      currentToolType = ToolType.pencil.name;
                      controller.setPKTool(
                        toolType: currentToolType,
                        width: currentWidth,
                        color: currentColor,
                      );
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.auto_fix_high,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      currentToolType = ToolType.marker.name;
                      controller.setPKTool(
                        toolType: currentToolType,
                        width: currentWidth,
                        color: currentColor,
                      );
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.earbuds_rounded,
                    color: Colors.pinkAccent,
                  ),
                  onPressed: () {
                    setState(() {
                      currentToolType = ToolType.eraserVector.name;
                      controller.setPKTool(
                        toolType: currentToolType,
                        width: currentWidth,
                        color: currentColor,
                      );
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.lens_outlined,
                    color: Colors.pinkAccent,
                  ),
                  onPressed: () {
                    setState(() {
                      currentToolType = ToolType.eraserBitmap.name;
                      controller.setPKTool(
                        toolType: currentToolType,
                        width: currentWidth,
                        color: currentColor,
                      );
                    });
                  },
                ),
              ],
            )),
            Expanded(
              child: PencilKit(
                onPencilKitViewCreated: (controller) =>
                    this.controller = controller,
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
