import Foundation

internal class ShellExecutor {
    func execute(_ launchPath: String, arguments: String...) -> String {
        let task = Process()
        task.launchPath = launchPath
        task.arguments = arguments

        let pipe = Pipe()
        task.standardOutput = pipe
        print("Executing \(launchPath) \(arguments.joined(separator: " "))")
        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: String.Encoding.utf8)!
    }
}
