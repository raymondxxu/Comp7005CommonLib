import Foundation

public class FileManager {
    
    private var fileManager: Foundation.FileManager
    private var currentDir: URL

    public static let shared: FileManager = FileManager()

    //singleton class private init
    private init() {
        fileManager = Foundation.FileManager.default
        currentDir = URL(fileURLWithPath: "")
    }
    
    public func crateWorkingDir(with clientIP: String) throws {
        currentDir.appendPathComponent(clientIP)
        var isDir: ObjCBool = true
        if !fileManager.fileExists(atPath: currentDir.absoluteString,
                                   isDirectory: &isDir) {
            try fileManager.createDirectory(at: currentDir,
                                             withIntermediateDirectories: true)
        }
    }

    public func goBackToParentFolder () {
        currentDir.deleteLastPathComponent()
    }
    
    public func changeWorkingDir(with clientIP: String) throws {
        currentDir.deleteLastPathComponent()
        try crateWorkingDir(with: clientIP)
    }
    
    public func createFile(with fileName: String, for content: String) throws {
        let fileNameWithoutExtension = fileName.split(separator: ".").first!
        func createFile(with versionNumber: Int) -> String {
            return "\(fileNameWithoutExtension)_v\(versionNumber).txt"
        }
        let files = try fileManager.contentsOfDirectory(at: currentDir,includingPropertiesForKeys: nil).filter {
            $0.lastPathComponent.starts(with: fileNameWithoutExtension)
        }
        var filePath = currentDir
        if files.isEmpty {
            filePath.appendPathComponent(fileName)
        } else {
            let fileNumberWithVersionNumber = createFile(with: files.count)
            filePath.appendPathComponent(fileNumberWithVersionNumber)
        }
        fileManager.createFile(atPath: filePath.path, contents: nil)
        try! content.write(to: filePath, atomically: true, encoding: .ascii)
    }
    
    public func readingFile(with fileName: String) throws -> String {
        let filePath = currentDir.appendingPathComponent(fileName)
        let fileContent = try! String(contentsOfFile: filePath.path)
        return fileContent
    }

    public func getAllTxtFile() -> [String] {
        fileManager.subpaths(atPath: currentDir.path)?.filter{ $0.hasSuffix(".txt")} ?? [String]()
    }

}

