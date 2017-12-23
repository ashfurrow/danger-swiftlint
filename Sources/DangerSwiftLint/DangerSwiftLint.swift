import Danger
import Foundation

public struct SwiftLint {
    internal static let danger = Danger()
    internal static let shellExecutor = ShellExecutor()

    /// This is the main entry point for linting Swift in PRs using Danger-Swift.
    /// Call this function anywhere from within your Dangerfile.swift.
    @discardableResult
    public static func lint() -> [Violation] {
        return self.lint(danger: danger, shellExecutor: shellExecutor)
    }
}

/// This extension is for internal workings of the plugin. It is marked as internal for unit testing.
internal extension SwiftLint {
    static func lint(
        danger: DangerDSL,
        shellExecutor: ShellExecutor,
        markdown: (String) -> Void = markdown,
        fail: (String) -> Void = fail) -> [Violation] {
        // Gathers modified+created files, invokes SwiftLint on each, and posts collected errors+warnings to Danger.
        var allViolations = Array<Violation>()
        let decoder = JSONDecoder()
        let files = danger.git.createdFiles + danger.git.modifiedFiles

        // So, we need to find out where the swiftlint tool is installed.
        let swiftlintPath = shellExecutor.execute("which", arguments: "swiftlint")
        print("Found swiftlint executable: \(swiftlintPath)")

        files.filter { $0.hasSuffix(".swift") }.forEach { file in
            let outputJSON = shellExecutor.execute(swiftlintPath, arguments: "lint", "--path \(file)", "--reporter json")
            do {
                let violations = try decoder.decode([Violation].self, from: outputJSON.data(using: String.Encoding.utf8)!)
                allViolations += violations
            } catch let error {
                fail("Error deserializing SwiftLint JSON response (\(file)): \(error)")
            }
        }

        if !allViolations.isEmpty {
            var markdownMessage = """
            ### SwiftLint found issues

            | Severity | File | Reason |
            | -------- | ---- | ------ |\n
            """
            markdownMessage += allViolations.map { $0.toMarkdown() }.joined(separator: "\n")
            markdown(markdownMessage)
        }

        return allViolations
    }
}
