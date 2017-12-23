import XCTest
import Danger
@testable import DangerSwiftLint

class DangerSwiftLintTests: XCTestCase {
    var executor: FakeShellExecutor!
    var danger: DangerDSL!
    var markdownMessage: String?

    override func setUp() {
        executor = FakeShellExecutor()
        FileManager.default.changeCurrentDirectoryPath("/Users/ash/bin/danger-swiftlint")
        let dslJSONContents = FileManager.default.contents(atPath: "./Tests/Fixtures/harness.json")!
        danger = try! JSONDecoder().decode(DSL.self, from: dslJSONContents).danger
        markdownMessage = nil
    }

    func testExecutesTheShell() {
        _ = SwiftLint.lint(danger: danger, shellExecutor: executor)
        XCTAssertNotEqual(executor.invocations.count, 0)
    }

    func testFiltersOnSwiftFiles() {
        _ = SwiftLint.lint(danger: danger, shellExecutor: executor)
        let filesExtensions = Set(executor.invocations.flatMap { $0.arguments[1].split(separator: ".").last })
        XCTAssertEqual(filesExtensions, ["swift"])
    }

    func testPrintsNoMarkdownIfNoViolations() {
        _ = SwiftLint.lint(danger: danger, shellExecutor: executor)
        XCTAssertNil(markdownMessage)
    }

    func testViolations() {
        mockViolationJSON()
        let violations = SwiftLint.lint(danger: danger, shellExecutor: executor, markdown: writeMarkdown)
        XCTAssertEqual(violations.count, 2) // Two files, one (identical oops) violation returned for each.
    }

    func testMarkdownReporting() {
        mockViolationJSON()
        _ = SwiftLint.lint(danger: danger, shellExecutor: executor, markdown: writeMarkdown)
        XCTAssertNotNil(markdownMessage)
        XCTAssertTrue(markdownMessage!.contains("SwiftLint found issues"))
    }

    func mockViolationJSON() {
        executor.output = """
        [
            {
                "rule_id" : "opening_brace",
                "reason" : "Opening braces should be preceded by a single space and on the same line as the declaration.",
                "character" : 39,
                "file" : "/Users/ash/bin/Harvey/Sources/Harvey/Harvey.swift",
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

    static var allTests = [
        ("testExample", testExecutesTheShell),
    ]
}
