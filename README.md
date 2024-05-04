# Flutter iOS Pencil Kit

<img width="883" alt="PencilKitMJStudio" src="https://user-images.githubusercontent.com/33388801/197379199-56d74575-6f80-4afe-b916-6b09efc4c256.png">

[![](https://github.com/mj-studio-library/flutter-pencilkit/actions/workflows/analyze_and_test.yml/badge.svg?branch=main)](https://github.com/mj-studio-library/flutter-pencilkit)
[![pub package](https://img.shields.io/pub/v/pencil_kit.svg)](https://pub.dev/packages/pencil_kit)
[![All Contributors](https://img.shields.io/badge/all_contributors-3-blue.svg?style=flat-square)](#contributors-)
[![licence](https://img.shields.io/badge/licence-MIT-blue.svg)](https://github.com/mj-studio-library/flutter-pencilkit/blob/main/LICENSE)

#### Flutter plugin for using iOS Pencil Kit

<img src="https://raw.githubusercontent.com/mym0404/image-archive/master/202405041708722.webp" alt="preview"/>

[Changelog](/CHANGELOG.md)

### Note 📒

- This package only provides iOS implementation. If you try use widget of this package other than
  iOS, you see a Red warning box.
- iOS Pencil Kit is available from iOS `13.0`

### Supported Platforms 📱

- **iOS**

### Highlights 🌟

- [x] Drawing
- [x] Show/Hide palette
- [x] Undo/Redo
- [x] Clear
- [x] UI properties(background color, scrollability, isOpaque, etc...)
- [x] Import/Export drawing data
- [x] Get drawing png/jpeg image data as base64
- [x] Manage drawing tools programmatically

### Requirements ✅

- **iOS**: Deployment target >= `9.0`

## Setup & Usage 🎉

```shell
flutter pub add pencil_kit
```

## Available Methods

Methods available for `PencilKitController`.

| Method                                                                             | Description                                                                             | Throws | Etc                                                                          |
|------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------|--------|------------------------------------------------------------------------------|
| clear()                                                                            | Clear canvas                                                                            | X      |                                                                              |
| show()                                                                             | Show Palette                                                                            | X      |                                                                              |
| hide()                                                                             | Hide Palette                                                                            | X      |                                                                              |
| redo()                                                                             | Redo last drawing action                                                                | X      |                                                                              |
| undo()                                                                             | Undo last drawing action                                                                | X      |                                                                              |
| save(): Future<String?>                                                            | Save drawing data into file system, can return base 64 data if `withBase64Data` is true | O      |                                                                              |
| load(): Future<String?>                                                            | Load drawing data from file system, can return base 64 data if `withBase64Data` is true | O      |                                                                              |
| getBase64Data(): Future<String>                                                    | Get current drawing data as base64 string form                                          | O      |                                                                              |
| loadBase64Data(String base64Data): Future<void>                                    | Load base64 drawing data into canvas                                                    | O      |                                                                              |
| getBase64PngData(): Future<String>                                                 | Get current drawing data as png base64 string form                                      | O      | scale = 0 means use default UIScreen.main.scale                              |
| getBase64JpegData(): Future<String>                                                | Get current drawing data as jpeg base64 string form                                     | O      | scale = 0 means use default UIScreen.main.scale. default compression is 0.93 |
| setPKTool({required ToolType toolType, double? width, Color? color}): Future<void> | Set `PKTool` type with width and color                                                  | X      |                                                                              |

## Caution for `setPKTool`

`setPKTool` can fail if tool type is not supported by device iOS version
In eraser tools, the width parameter will work only from iOS 16.4 or above iOS version

You should check whether feature is available in user's iOS version
with [ToolType.isAvailableFromIos16_4] and [ToolType.isAvailableFromIos17]

Read more about `ToolType` type definition.

<details>
<summary>Type definition</summary>

```dart
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
```

</details>

## `PencilKit` Widget Parameters

All the available parameters.

| Parameter                         | Description                                                                                                                    |     |
|-----------------------------------|--------------------------------------------------------------------------------------------------------------------------------|-----|
| onPencilKitViewCreated            | A callback for platform view created. You can store `PencilKitController` from argument of this callback.                      |     |
| hitTestBehavior                   | iOS `UIKitView` `hitTestBehavior`                                                                                              |     |
| unAvailableFallback               | A widget for render UnAvailable state. The default is A red box                                                                |     |
| alwaysBounceVertical              | A Boolean value that determines whether bouncing always occurs when vertical scrolling reaches the end of the content.         |     |
| alwaysBounceHorizontal            | A Boolean value that determines whether bouncing always occurs when horizontal scrolling reaches the end of the content view.  |     |
| isRulerActive                     | A Boolean value that indicates whether a ruler view is visible on the canvas.                                                  |     |
| drawingPolicy                     | The policy that controls the types of touches allowed when drawing on the canvas. This properties can be applied from iOS 14.0 |     |
| toolPickerVisibilityDidChange     | Tells the delegate that the tool picker UI changed visibility.                                                                 |     |
| toolPickerIsRulerActiveDidChange  | Tells the delegate that the ruler active state was changed by the user.                                                        |     |
| toolPickerFramesObscuredDidChange | Tells the delegate that the frames the tool picker obscures changed.                                                           |     |
| toolPickerSelectedToolDidChange   | Tells the delegate that the selected tool was changed by the user.                                                             |     |
| canvasViewDidBeginUsingTool       | Called when the user starts using a tool, eg. selecting, drawing, or erasing.                                                  |     |
| canvasViewDidEndUsingTool         | Called when the user stops using a tool, eg. selecting, drawing, or erasing.                                                   |     |
| canvasViewDrawingDidChange        | Called after the drawing on the canvas did change.                                                                             |     |
| canvasViewDidFinishRendering      | Called after setting `drawing` when the entire drawing is rendered and visible.                                                |     |

## Contribution

Please read [CONTRIBUTING.md](/CONTRIBUTING.md) and contribute your works! Thank you :)

## Example

Check example on [pub.dev](https://pub.dev/packages/pencil_kit/example) page
or [example project repo](example)

## Troubleshooting

- I get a `Pencil Kit XXX+ ms` and it freezes.
  - Turn off `Graphics HUD` menu in iOS Developer Settings. [#22](https://github.com/mym0404/flutter-pencilkit/issues/22)

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://www.mjstudio.net/"><img src="https://avatars.githubusercontent.com/u/33388801?v=4?s=100" width="100px;" alt="MJ Studio"/><br /><sub><b>MJ Studio</b></sub></a><br /><a href="#ideas-mym0404" title="Ideas, Planning, & Feedback">🤔</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/jack-szeto"><img src="https://avatars.githubusercontent.com/u/47553851?v=4?s=100" width="100px;" alt="Jack Szeto"/><br /><sub><b>Jack Szeto</b></sub></a><br /><a href="https://github.com/mj-studio-library/flutter-pencilkit/commits?author=jack-szeto" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/frybitsinc"><img src="https://avatars.githubusercontent.com/u/16763975?v=4?s=100" width="100px;" alt="frybitsinc"/><br /><sub><b>frybitsinc</b></sub></a><br /><a href="https://github.com/mj-studio-library/flutter-pencilkit/commits?author=frybitsinc" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/bomb0069"><img src="https://avatars.githubusercontent.com/u/1587783?v=4?s=100" width="100px;" alt="bomb0069"/><br /><sub><b>bomb0069</b></sub></a><br /><a href="https://github.com/mj-studio-library/flutter-pencilkit/commits?author=bomb0069" title="Code">💻</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors)
specification. Contributions of any kind welcome!
