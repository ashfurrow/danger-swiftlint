@testable import DangerSwiftLint

final class FakeCurrentPathProvider: CurrentPathProvider {
    var currentPath: String = ""
}
