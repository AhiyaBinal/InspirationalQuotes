//
//  main.swift
//  Preprocessor
//
//  Created by Krunoslav Zaher on 4/22/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation

if CommandLine.argc != 3 {
    print("./Preprocessor <source-files-root> <derived-data> ")
    exit(-1)
}

let sourceFilesRoot = CommandLine.arguments[1]
let derivedData = CommandLine.arguments[2]

let fileManager = FileManager()

func escape(value: String) -> String {
    let escapedString = value.replacingOccurrences(of: "\n", with: "\\n")
    let escapedString1 = escapedString.replacingOccurrences(of: "\r", with: "\\r")
    let escapedString2 = escapedString1.replacingOccurrences(of: "\"", with: "\\\"")

    return "\"\(escapedString2)\""
}

func processFile(path: String, outputPath: String) -> String {
    let url = URL(fileURLWithPath: path)
    let rawContent = try! Data(contentsOf: url)
    let content = String(data: rawContent, encoding: String.Encoding.utf8)

    guard let components = content?.components(separatedBy: "<%") else { return "" }

    var functionContentComponents: [String] = []
    functionContentComponents.append("var components: [String] = [\"// This file is autogenerated. Take a look at `Preprocessor` target in RxSwift project \\n\"]\n")
    functionContentComponents.append("components.append(\(escape(value: components[0])))\n")

    for codePlusSuffix in (components[1 ..< components.count]) {
        let codePlusSuffixSeparated = codePlusSuffix.components(separatedBy: "%>")
        if codePlusSuffixSeparated.count != 2 {
            fatalError("Error in \(path) near \(codePlusSuffix)")
        }

        let code = codePlusSuffixSeparated[0]
        let suffix = codePlusSuffixSeparated[1]

        if code.hasPrefix("=") {
            functionContentComponents.append("components.append(String(\(String(code[code.index(after: code.startIndex) ..< code.endIndex]))))\n")
        }
        else {
            functionContentComponents.append("\(code)\n")
        }

        functionContentComponents.append("components.append(\(escape(value: suffix)));\n")
    }

    functionContentComponents.append("try! components.joined(separator:\"\").write(toFile:\"\(outputPath)\", atomically: false, encoding: String.Encoding.utf8)")

    return functionContentComponents.joined(separator: "")
}

func runCommand(path: String) {
    _ = ProcessInfo().processIdentifier

    let process = Process()
    process.launchPath = "/bin/bash"
    process.arguments = ["-c", "xcrun swift \"\(path)\""]

    process.launch()

    process.waitUntilExit()

    if process.terminationReason != .exit {
        exit(-1)
    }
}

let files = try fileManager.subpathsOfDirectory(atPath: sourceFilesRoot)

var generateAllFiles = ["// Generated code\n", "import Foundation\n"]

for file in files {
    if ((file as NSString).pathExtension) != "tt" {
        continue
    }

    print(file)

    let path = (sourceFilesRoot as NSString).appendingPathComponent(file as String)
    let endIndex = path.index(before: path.index(before: path.index(before: path.endIndex)))
    let outputPath = String(path[path.startIndex ..<  endIndex]) + ".swift"

    generateAllFiles.append("_ = { () -> Void in\n\(processFile(path: path, outputPath: outputPath))\n}()\n")
}

let script = generateAllFiles.joined(separator: "")
let scriptPath = (derivedData as NSString).appendingPathComponent("_preprocessor.sh")

do {
    try script.write(toFile: scriptPath, atomically: true, encoding: String.Encoding.utf8)
} catch _ {
}
runCommand(path: scriptPath)
