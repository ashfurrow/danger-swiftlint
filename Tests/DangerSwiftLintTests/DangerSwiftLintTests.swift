import XCTest
import Danger
@testable import DangerSwiftLint

class DangerSwiftLintTests: XCTestCase {
    var executor: FakeShellExecutor!
    var danger: DangerDSL!
    var markdownMessage: String?

    override func setUp() {
        executor = FakeShellExecutor()
        let localPath = URL(string: #file)!.deletingLastPathComponent(2).absoluteString
        FileManager.default.changeCurrentDirectoryPath(localPath)
        danger = parseDangerDSL(at: "./Tests/Fixtures/harness.json")
        markdownMessage = nil
    }

    func testExecutesTheShell() {
        _ = SwiftLint.lint(danger: danger, shellExecutor: executor)
        XCTAssertNotEqual(executor.invocations.dropFirst().count, 0)
    }

    func testExecuteSwiftLintInInlineMode() {
        mockViolationJSON()
        var warns = [(String, String, Int)]()
        let warnAction: (String, String, Int) -> Void = { warns.append(($0, $1, $2)) }

        _ = SwiftLint.lint(danger: danger, shellExecutor: executor, inline: true, warnInlineAction: warnAction)

        XCTAssertTrue(warns.first?.0 == "Opening braces should be preceded by a single space and on the same line as the declaration.")
        XCTAssertTrue(warns.first?.1 == "SomeFile.swift")
        XCTAssertTrue(warns.first?.2 == 8)
    }

    func testExecutesSwiftLintWithConfigWhenPassed() {
        let configFile = "/Path/to/config/.swiftlint.yml"

        _ = SwiftLint.lint(danger: danger, shellExecutor: executor, configFile: configFile)

        let swiftlintCommands = executor.invocations.filter { $0.command == "swiftlint" }
        XCTAssertTrue(swiftlintCommands.count > 0)
        swiftlintCommands.forEach { command, arguments in
            XCTAssertTrue(arguments.contains("--config \"\(configFile)\""))
        }
    }

    func testExecutesSwiftLintWithDirectoryPassed() {
        let directory = "Tests"
        danger = parseDangerDSL(at: "./Tests/Fixtures/harness_directories.json")

        _ = SwiftLint.lint(danger: danger, shellExecutor: executor, directory: directory)
        
        let swiftlintCommands = executor.invocations.filter { $0.command == "swiftlint" }
        XCTAssertTrue(swiftlintCommands.count == 1)
        XCTAssertTrue(swiftlintCommands.first!.arguments.contains("--path \"Tests/SomeFile.swift\""))
    }

    func testFiltersOnSwiftFiles() {
        _ = SwiftLint.lint(danger: danger, shellExecutor: executor)

        let quoteCharacterSet = CharacterSet(charactersIn: "\"")
        let filesExtensions = Set(executor.invocations.dropFirst().flatMap { $0.arguments[2].split(separator: ".").last?.trimmingCharacters(in: quoteCharacterSet) })
        XCTAssertEqual(filesExtensions, ["swift"])
    }

    func testPrintsNoMarkdownIfNoViolations() {
        _ = SwiftLint.lint(danger: danger, shellExecutor: executor)
        XCTAssertNil(markdownMessage)
    }

    func testViolations() {
        mockViolationJSON()
        let violations = SwiftLint.lint(danger: danger, shellExecutor: executor, markdownAction: writeMarkdown)
        XCTAssertEqual(violations.count, 2) // Two files, one (identical oops) violation returned for each.
    }

    func testMarkdownReporting() {
        mockViolationJSON()
        _ = SwiftLint.lint(danger: danger, shellExecutor: executor, markdownAction: writeMarkdown)
        XCTAssertNotNil(markdownMessage)
        XCTAssertTrue(markdownMessage!.contains("SwiftLint found issues"))
    }

    func testQuotesPathArguments() {
        danger = parseDangerDSL(at: "./Tests/Fixtures/harness_directories.json")

        _ = SwiftLint.lint(danger: danger, shellExecutor: executor)

        let swiftlintCommands = executor.invocations.filter { $0.command == "swiftlint" }

        XCTAssertTrue(swiftlintCommands.count > 0)

        let spacedDirSwiftlintCommands = swiftlintCommands.filter { (_, arguments) in
            arguments.contains("--path \"Test Dir/SomeThirdFile.swift\"")
        }

        XCTAssert(spacedDirSwiftlintCommands.count == 1)
    }

    func mockViolationJSON() {
        executor.output = """
        [
            {
                "rule_id" : "opening_brace",
                "reason" : "Opening braces should be preceded by a single space and on the same line as the declaration.",
                "character" : 39,
                "file" : "/Users/ash/bin/SomeFile.swift",
                "severity" : "Warning",
                "type" : "Opening Brace Spacing",
                "line" : 8
            }
        ]
        """
    }

    func writeMarkdown(_ m: String) {
        markdownMessage = m
    }

    func parseDangerDSL(at path: String) -> DangerDSL {
        let dslJSONContents = FileManager.default.contents(atPath: path)!
        let decoder = JSONDecoder()
        if #available(OSX 10.12, *) {
            decoder.dateDecodingStrategy = .iso8601
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
        }
        return try! decoder.decode(DSL.self, from: dslJSONContents).danger
    }

    static var allTests = [
        ("testExecutesTheShell", testExecutesTheShell),
        ("testExecutesSwiftLintWithConfigWhenPassed", testExecutesSwiftLintWithConfigWhenPassed),
        ("testExecutesSwiftLintWithDirectoryPassed", testExecutesSwiftLintWithDirectoryPassed),
        ("testFiltersOnSwiftFiles", testFiltersOnSwiftFiles),
        ("testPrintsNoMarkdownIfNoViolations", testPrintsNoMarkdownIfNoViolations),
        ("testViolations", testViolations),
        ("testMarkdownReporting", testMarkdownReporting),
        ("testQuotesPathArguments", testQuotesPathArguments)
    ]
}
