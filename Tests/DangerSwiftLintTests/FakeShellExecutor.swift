@testable import DangerSwiftLint

class FakeShellExecutor: ShellExecutor {
    typealias Invocation = (launchPath: String, arguments: [String])

    var invocations = Array<Invocation>() /// All of the invocations received by this instance.
    var output = "[]" /// This is returned by `execute` as the process' standard output. We default to an empty JSON array.

    override func execute(_ launchPath: String, arguments: String...) -> String {
        invocations.append((launchPath: launchPath, arguments: arguments))
        return output
    }
}
