# Flutter iOS Pencil Kit

<img width="883" alt="PencilKitMJStudio" src="https://user-images.githubusercontent.com/33388801/197379199-56d74575-6f80-4afe-b916-6b09efc4c256.png">


[![](https://github.com/mj-studio-library/flutter-pencilkit/actions/workflows/analyze_and_test.yml/badge.svg?branch=main)](https://github.com/mj-studio-library/flutter-pencilkit)
[![pub package](https://img.shields.io/pub/v/pencil_kit.svg)](https://pub.dev/packages/pencil_kit)
[![All Contributors](https://img.shields.io/badge/all_contributors-1-blue.svg?style=flat-square)](#contributors-)
[![licence](https://img.shields.io/badge/licence-MIT-blue.svg)](https://github.com/mj-studio-library/flutter-pencilkit/blob/main/LICENSE)



#### Flutter plugin for using iOS Pencil Kit.

<img src="https://user-images.githubusercontent.com/33388801/197273399-e602b742-87bc-4e59-85fe-76b80915f448.png" width=240/>


### Note 📒
- This package only provides iOS implementation. If you try use widget of this package other than iOS, you see a Red warning box.
- iOS Pencil Kit is available from iOS `13.0`

### Supported Platforms 📱
- **iOS**

### Features & Todo 🌟

- [x] Drawing
- [x] Show/Hide palette
- [x] Undo/Redo
- [x] Clear
- [x] UI properties(background color, scrollability, isOpaque, etc...)
- [ ] Manage drawing tools programmatically
- [ ] Import/Export drawing data

### Requirements ✅
* **iOS**: Deployment target >= `9.0`

## Setup & Usage 🎉

```shell
flutter pub add pencil_kit
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


| Parameter                     | Description                                                                                                                    |
|-------------------------------|--------------------------------------------------------------------------------------------------------------------------------|
| onPencilKitViewCreated        | A callback for platform view created. You can store `PencilKitController` from argument of this callback.                      |
| hitTestBehavior               | iOS `UIKitView` `hitTestBehavior`                                                                                              |
| unAvailableFallback           | A widget for render UnAvailable state. The default is A red box                                                                |
| alwaysBounceVertical          | A Boolean value that determines whether bouncing always occurs when vertical scrolling reaches the end of the content.         |
| alwaysBounceHorizontal        | A Boolean value that determines whether bouncing always occurs when horizontal scrolling reaches the end of the content view.  |
| isRulerActive                 | A Boolean value that indicates whether a ruler view is visible on the canvas.                                                  |
| drawingPolicy                 | The policy that controls the types of touches allowed when drawing on the canvas. This properties can be applied from iOS 14.0 |
| onToolPickerVisibilityChanged | A callback for tool picker visibility state changed                                                                            |
| onRulerActiveChanged          | A callback for ruler activate state changed                                                                                    |

## Example

Check example on [pub.dev](https://pub.dev/packages/pencil_kit/example) page or [example project repo](example)


## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center"><a href="https://www.mjstudio.net/"><img src="https://avatars.githubusercontent.com/u/33388801?v=4?s=100" width="100px;" alt="MJ Studio"/><br /><sub><b>MJ Studio</b></sub></a><br /><a href="#ideas-mym0404" title="Ideas, Planning, & Feedback">🤔</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
