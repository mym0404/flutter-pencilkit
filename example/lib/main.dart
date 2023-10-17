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
  String? drawingData = null;
  String currentToolType = ToolType.pen.name;
  double currentWidth = 1;
  Color currentColor = Colors.black;

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
                    SizedBox(),
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
                          onPressed: () {
                            controller.clear();
                          },
                        ),
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
                    ),
                    Row(
                      children: [
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
                      ],
                    ),
                    // add buttons for new feature - save, reload, export
                    Row(
                      children: [
                        // save button
                        IconButton(
                          icon: const Icon(
                            Icons.save,
                            color: Colors.black,
                          ),
                          onPressed: () async {
                            controller.save();
                          },
                        ),
                        // reload button
                        IconButton(
                          icon: const Icon(
                            Icons.download,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            controller.reload(drawingData);
                          },
                        ),
                        // export button
                        // IconButton(
                        //   icon: const Icon(
                        //     Icons.download,
                        //     color: Colors.black,
                        //   ),
                        //   onPressed: () => controller.export(drawingData),
                        // ),
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
                  onTapSaveCallback: (val) {
                    drawingData = val;
                  },
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}

enum ToolType {
  pen,
  pencil,
  marker,
  eraserVector,
  eraserBitmap,
}
