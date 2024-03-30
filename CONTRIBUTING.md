# Contributing to Flutter PencilKit

- [Flutter's code of conduct](https://github.com/flutter/flutter/blob/master/CODE_OF_CONDUCT.md)

## Setup the Project

The following steps will get you up and running to contribute to this package:

1. Fork the repo

2. Clone your fork locally

3. Setup all the dependencies and packages by running `yarn && flutter pub get`.

4. Run `yarn check:all` anytime to ensure format, typing aren't broken.

## Commit Convention

Before you create a Pull Request, please check whether your commits comply with
the commit conventions used in this repository.

Rules through commitlint are applied, and correct commit messages can be created with git cz through commitizen.

- [commitlint](https://commitlint.js.org/)
- [commitizen cz-cli](https://github.com/commitizen/cz-cli)

When you create a commit we kindly ask you to follow the convention
`category(scope or module, optional): message` in your commit message while using one of
the following categories:

- `feat / feature`: all changes that introduce completely new code or new
  features
- `fix`: changes that fix a bug (ideally you will additionally reference an
  issue if present)
- `refactor`: any code related change that is not a fix nor a feature
- `docs`: changing existing or creating new documentation (i.e. README, docs for
  usage of a lib or cli usage)
- `build`: all changes regarding the build of the software, changes to
  dependencies or the addition of new dependencies
- `test`: all changes regarding tests (adding new tests or changing existing
  ones)
- `ci`: all changes regarding the configuration of continuous integration (i.e.
  github actions, ci system)
- `chore`: all changes to the repository that do not fit into any of the above
  categories

If you are interested in the detailed specification you can visit
<https://www.conventionalcommits.org/> or check out the
[Angular Commit Message Guidelines](https://github.com/angular/angular/blob/22b96b9/CONTRIBUTING.md#-commit-message-guidelines).

## Code Style

Flutter plugins follow Google style—or Flutter style for Dart—for the languages they
use, and use auto-formatters:

- Dart: formatted with `dart format`
- Swift: formatted with [swiftformat](https://github.com/nicklockwood/SwiftFormat) the config file is ios/.swiftformat

## Documentation(dart doc)

If you fix a bug or create a new feature, then you should write or modify comment of source code with [dart doc](https://dart.dev/effective-dart/documentation) style.

Any function or parameter should be described in dart doc comment and [README.md](/README.md)

If you think any code should be described itself, then write code with inline comment at that line.

## Steps to PR

1. Fork of the this repository and clone your fork

2. Create a new branch out of the `main` branch.

3. Make and commit your changes following the
   [commit convention](https://github.com/mj-studio-library/react-native-styled-system/blob/main/CONTRIBUTING.md#commit-convention).
   As you develop, you can run `yarn check:all` and to make sure everything works as expected.

4. You should base branch of PR as `main`.

## Development

If you change dart code, open this repository with IDE and change it.

If you change swift code, open `example/ios/Runner.xcworkspace` with Xcode and edit code at Pods/Development `Pods/pencil_kit/../../example/ios/.symlinks/plugins/pencil_kit/ios/Classes`

Please refer to the following picture.

![screenshot](https://raw.githubusercontent.com/mym0404/image-archive/master/202403301904333.webp)

## Example Project

While developing, you can run the example app to test your changes.
If you change any native code, then you'll need to rebuild the example app.

## License

By contributing your code to the flutter-pencilkit GitHub repository, you agree to
license your contribution under the MIT license.
