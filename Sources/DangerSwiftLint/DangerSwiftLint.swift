import Danger

public struct SwiftLint {
    static let danger = Danger()
    public static func lint() {
        /*
         TODO:
         - Gather modified+created files
         - Invoke SwiftLint
         - Post errors+warnings
         */
        print("Hello! \(danger.git.modifiedFiles)")
    }
}

