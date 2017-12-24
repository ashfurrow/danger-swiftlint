[![CircleCI](https://circleci.com/gh/ashfurrow/danger-swiftlint.svg?style=svg)](https://circleci.com/gh/ashfurrow/danger-swiftlint)

# Danger SwiftLint

[Danger Swift](https://github.com/danger/danger-swift) plugin for [SwiftLint](https://github.com/realm/SwiftLint/).

(**Note**: If you're looking for the _Ruby_ version of this Danger plugin, it has been moved [here](https://github.com/ashfurrow/danger-ruby-swiftlint).)

## Usage

[Install and run](https://github.com/danger/danger-swift#ci-configuration) DangerSwift as normal and install SwiftLint in your CI's config file. Something like:

```yaml
dependencies:
  override:
  - npm install -g danger # This and the next line are just for Danger-Swift.
  - brew install danger/tap/danger-swift
  - brew install swiftlint # This is for the Danger Swiftlint plugin.
```

Then use the following `Dangerfile.swift`.

```swift
// Dangerfile.swift

import Foundation
import Danger
import DangerSwiftLint // package: https://github.com/danger/DangerSwiftLint.git

let danger = Danger()

SwiftLint.lint()
```

# Contributing

If you find a bug, please [open an issue](https://github.com/ashfurrow/danger-swiftlint/issues/new)! Or a pull request :wink:

# Customizing

There are tonnes of ways this plugin can be customized for individual use cases. After building [the Ruby version](https://github.com/ashfurrow/danger-ruby-swiftlint) of this plugin, I realized that it's really difficult to scale up a tool that works for everyone. So instead, this plugin is a template for you to do whatever you want with!

1. [Fork](https://github.com/ashfurrow/danger-swiftlint#fork-destination-box) this project.
1. Change the `import DangerSwiftLint` package URL to point to your fork.
1. After making your changes to the plugin, push them to your fork and **push a new tag**.

Because you need to tag a new version, testing your plugin can be tricky. I've built some basic unit tests, so you should be able to use test-driven development for most of your changes.

If you think you've got a real general-purpose feature that most users of this plugin would benefit from, I would be grateful for a pull request.

# License

[#MIT4Lyfe](LICENSE)

# A Fun GIF

<details>
<summary>Your feeling when you lint your swift code</summary>
<img src="https://imgur.com/L6NkEtz.gif" />
</details>
