# Flutter iOS Pencil Kit

[![licence](https://img.shields.io/badge/licence-MIT-orange.svg)](https://github.com/mj-studio-library/flutter-pencilkit/blob/main/LICENSE)

#### Flutter plugin for using iOS Pencil Kit.

### Note 📒
- This package only provides iOS implementation. If you try use widget of this package other than iOS, you see a Red warning box.
- iOS Pencil Kit is available from iOS `13.0`

### Supported Platforms 📱
- **iOS**



### Features & Todo 🌟

At now, package is very first version. So some feature is missing :)

- [x] Drawing
- [x] Show/Hide palette
- [x] Undo/Redo
- [x] Clear
- [ ] Import/Export drawing data
- [ ] UI properties(background color, scrollability, etc...)

### Requirements ✅
* **iOS**: Deployment target >= `9.0`

## Setup & Usage 🎉

```shell
flutter pub add flutter_pencil_kit
```


### Example

```dart
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
        body: Container(
          color: Colors.blueAccent.withOpacity(0.2),
          child: PencilKit(
            onPencilKitViewCreated: (controller) => this.controller = controller,
          ),
        ),
      ),
    );
  }
}
```

## Available Methods
Methods available for `PencilKitController`.

| Method  | Description              |
|---------|--------------------------|
| clear() | Clear canvas             |
| show()  | Show Palette             |
| hide()  | Hide Palette             |
| redo()  | Redo last drawing action |
| undo()  | Undo last drawing action |


## `PencilKit` Widget Parameters
All the available parameters.


| Parameter              | Description                                                                                               |
|------------------------|-----------------------------------------------------------------------------------------------------------|
| onPencilKitViewCreated | A callback for platform view created. You can store `PencilKitController` from argument of this callback. |
| hitTestBehavior   | iOS `UIKitView` `hitTestBehavior`                                                                         |
