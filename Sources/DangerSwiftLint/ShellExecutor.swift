import Foundation

internal class ShellExecutor {
    func execute(_ launchPath: String, arguments: String...) -> String {
        var env = ProcessInfo.processInfo.environment
        let task = Process()
        task.launchPath = env["SHELL"]
        task.arguments = ["-l", "-c", launchPath] + arguments

        let pipe = Pipe()
        task.standardOutput = pipe
        print("Executing \(launchPath) \(arguments.joined(separator: " "))")
        task.launch()
        task.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: String.Encoding.utf8)!
    }
}
