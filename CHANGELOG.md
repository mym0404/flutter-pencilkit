## 2.1.0

* Add `getBase64PngData` command
* Add `getBase64JpegData` command
* Change selected tool in tool picker on tool changed programmatically

## 2.0.0

* Add callbacks
  * toolPickerVisibilityDidChange
  * toolPickerIsRulerActiveDidChange
  * toolPickerFramesObscuredDidChange
  * toolPickerSelectedToolDidChange
  * canvasViewDidBeginUsingTool
  * canvasViewDidEndUsingTool
  * canvasViewDrawingDidChange
  * canvasViewDidFinishRendering

To avoid confusion, the names of the callbacks were taken directly from the native code.

The detailed method of callback is left in dart doc comment.

### Breaking Change
- The `onToolPickerVisibilityChanged` is renamed to `toolPickerVisibilityDidChange`
- The `onRulerActiveChanged` is renamed to `toolPickerIsRulerActiveDidChange`

## 1.0.8

* Add `setPKTool` method by [PR](https://github.com/mj-studio-library/flutter-pencilkit/pull/18) by [frybitsinc](https://github.com/frybitsinc)

Thank you for contributing

## 1.0.7

* Added loadBase64Data feature [PR](https://github.com/mj-studio-library/flutter-pencilkit/pull/12) by [jack-szeto](https://github.com/jack-szeto)

Thank you for contributing

## 1.0.6

* Add parameter `withBase64Data` in `save()` and `load()`
* Add `getBase64Data()` in controller

## 1.0.5

* Add `save()`, `load()` in controller

## 1.0.4

* restore `onToolPickerVisibilityChanged` parameter
* fix tool picker is not shown at first `show()` call (regression)
* initialize each `PKToolPicker` from iOS 14.0

## 1.0.3

* remove `onToolPickerVisibilityChanged` parameter
* fix tool picker is not shown at first `show()` call

## 1.0.2

* Fix tool connection is missing

## 1.0.1

* Delay controller initialization

## 1.0.0

* Configure CD

## 0.0.4

* Add several properties on `PencilKit` widget

## 0.0.3

* Add several properties on `PencilKit` widget

## 0.0.2+1

* Semantic release for updating README.md on pub.dev

## 0.0.2

* Semantic release for updating README.md on pub.dev

## 0.0.1 

* Initial Release
