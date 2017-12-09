# Danger Swiftlint

[Danger Swift](https://github.com/danger/danger-swift) plugin for [SwiftLint](https://github.com/realm/SwiftLint/). **This is a work in progress**.

(**Note**: If you're looking for the _Ruby_ version of this Danger plugin, it has been moved [here](https://github.com/ashfurrow/danger-ruby-swiftlint).)

## Usage

[Install and run](https://github.com/danger/danger-swift#ci-configuration) DangerSwift as normal, and use the following `Dangerfile.swift`.

```swift
// Dangerfile.swift

import Foundation
import Danger
import DangerSwiftLint // package: https://github.com/danger/DangerSwiftLint.git

let danger = Danger()

SwiftLint.lint()
```

# License

[#MIT4Lyfe](LICENSE)

# A Fun GIF

<details>
<summary>Your feeling when you lint your swift code</summary>
<img src="https://imgur.com/L6NkEtz.gif" />
</details>
