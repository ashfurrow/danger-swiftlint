[![CircleCI](https://circleci.com/gh/ashfurrow/danger-swiftlint.svg?style=svg)](https://circleci.com/gh/ashfurrow/danger-swiftlint)

# Danger SwiftLint

[Danger Swift](https://github.com/danger/danger-swift) plugin for [SwiftLint](https://github.com/realm/SwiftLint/). So you can get SwiftLint warnings on your pull requests!

(**Note**: If you're looking for the _Ruby_ version of this Danger plugin, it has been moved [here](https://github.com/ashfurrow/danger-ruby-swiftlint).)

## Usage

[Install and run](https://github.com/danger/danger-swift#ci-configuration) Danger Swift as normal and install SwiftLint in your CI's config file. Something like:

```yaml
dependencies:
  override:
  - npm install -g danger # This installs Danger
  - brew install danger/tap/danger-swift # This installs Danger-Swift
  - brew install swiftlint # This is for the Danger SwiftLint plugin.
```

Then use the following `Dangerfile.swift`.

```swift
// Dangerfile.swift

import Danger
import DangerSwiftLint // package: https://github.com/ashfurrow/danger-swiftlint.git

SwiftLint.lint()
```

That will lint the created and modified files

#### Inline mode

If you want the lint result shows in diff instead of comment, you can use inline_mode option. Violations that out of the diff will show in danger's fail or warn section.

```swift
SwiftLint.lint(inline: true)
```

#### Config & Directory

You can also specify a path to the config file using `configFile` parameter and a path to the directory you want to lint using `directory` parameter. This is helpful when you want to have different config files for different directories. E.g. Harvey wants to lint test files differently than the source files, thus they have the following  setup:

```swift
SwiftLint.lint(directory: "Sources", configFile: ".swiftlint.yml")
SwiftLint.lint(directory: "Tests", configFile: "Tests/HarveyTests/.swiftlint.yml")
```

It's not possible to use [nested configurations](https://github.com/realm/SwiftLint#nested-configurations), because Danger SwiftLint lints each file on it's own, and by doing that the nested configuration is disabled. If you want to learn more details about this, read the whole issue [here](https://github.com/ashfurrow/danger-swiftlint/issues/4).

# Contributing

If you find a bug, please [open an issue](https://github.com/ashfurrow/danger-swiftlint/issues/new)! Or a pull request :wink: 

No, seriously.

This is the first command line Swift I've ever written, and it's the first Danger Swift plugin _anyone_ has ever written, so if something doesn't work, I could really use your help figuring out the problem.

A good place to start is writing a failing unit test. Then you can try to fix the bug. First, you'll need to fork the repo and clone your fork locally. Build it and run the unit tests. 

```sh
git clone https://github.com/YOUR_USERNAME/danger-swiftlint.git
cd danger-swiftlint
swift build
swift test
```

Alright, verify that everything so far works before going further. To write your tests and modify the plugin files, run `swift package generate-xcodeproj`. Open the generated Xcode project and enjoy the modernities of code autocomplete and inline documentation. You can even run the unit tests from Xcode (sometimes results are inconsistent with running `swift test`).

One place that unit tests have a hard time covering is the integration with the `swiftlint` command line tool. If you're changing code there, open a pull request ([like this one](https://github.com/Moya/Harvey/pull/15)) to test everything works.

# Customizing

There are tonnes of ways this plugin can be customized for individual use cases. After building [the Ruby version](https://github.com/ashfurrow/danger-ruby-swiftlint) of this plugin, I realized that it's really difficult to scale up a tool that works for everyone. So instead, I'm treating this project as a template, that you to do fork and customize however you like!

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
