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

        let files = danger.git.createdFiles + danger.git.modifiedFiles
        let decoder = JSONDecoder()
        let violations = files.filter { $0.hasSuffix(".swift") }.flatMap { file in
            do {
                return try shellExecutor.execute("swiftlint", arguments: "lint", "--path \(file)", "--reporter json")
            } catch let error {
                fail("Error executing SwiftLint (\(file)): \(error)")
                return nil
            }
        }.flatMap { outputJSON -> [Violation] in
            do {
                return try decoder.decode([Violation].self, from: outputJSON.data(using: String.Encoding.utf8)!)
            } catch let error {
                fail("Error deserializing SwiftLint JSON response (\(outputJSON)): \(error)")
                return []
            }
        }

        if !violations.isEmpty {
            var markdownMessage = """
            ### SwiftLint found issues

            | Severity | File | Reason |
            | -------- | ---- | ------ |\n
            """
            markdownMessage += violations.map { $0.toMarkdown() }.joined(separator: "\n")
            markdown(markdownMessage)
        }

        return violations
    }
}
