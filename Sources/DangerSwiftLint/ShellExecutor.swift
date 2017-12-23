import Foundation
import ShellOut

internal class ShellExecutor {
    func execute(_ launchPath: String, arguments: String...) -> String {
        /*
         do {
         print(try shellOut(to: "which", arguments: ["swift"]))
         } catch let error {
         print(error)
         }

 */
        var env = ProcessInfo.processInfo.environment
//        env["PATH"] = env["PATH"]! + ":/usr/local/bin"
        print("PATH: ", env["PATH"])

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
