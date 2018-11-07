## Next

- Nothing yet!

## 0.4.0

- Addded `lintAllFiles` option to `SwiftLint.lint()`. This will lint all existing files (instead of just the added/modified ones). However, nested configurations works when this option is enabled.

## 0.3.0

- Added `inline` option to `SwiftLint.lint()`. This will trigger an inline comment instead of gathering all violations in a big main comment. For more details about inline mode, see [this docs in Danger JS](https://github.com/danger/danger-js/blob/master/CHANGELOG.md#340).

## 0.2.1

- Fixed bug where source and config file paths that contain spaces would trigger erronuous failure messages.

## 0.2.0

- Added `directory` & `configFile` options to `SwiftLint.lint()` function.

## 0.1.0

- This is the initial public relase.

