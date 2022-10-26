//
// Created by Raymond Xu on 2022-10-02.
//

import Foundation
import Socket

public enum ArgParserError: Error {
    case PortNumberError
    case ServerIPError
    case noFileNameFoundError
}

public class ArgParser {

    public private(set) var portNumber: UInt16?
    public private(set) var serverIp: NSString?
    public private(set) var serverDir: String?
    public private(set) var targetFileNames: Set<String>
    private var server: Bool

    public static let shared = ArgParser(server: false)
    public static let serverShared = ArgParser(server: true)

    private init(server:Bool) {
        targetFileNames = Set<String>()
        self.server = server
    }

    public func parse() throws {
        debugPrint(CommandLine.arguments)
        let args = CommandLine.arguments
        if args.contains("*.txt") {
            let fm = FileManager.shared
            fm.getAllTxtFile().forEach {
                targetFileNames.insert($0)
            }
        } else {
            args.filter {
                        $0.hasSuffix(".txt")
                    }
                    .forEach {
                        targetFileNames.insert($0)
                    }
        }


        for i in 0..<args.count {
            if args[i] == "-p" {
                if let pn = UInt16(args[i + 1]) {
                    portNumber = pn
                } else {
                    throw ArgParserError.PortNumberError
                }
            } else if args[i] == "-s" {
                serverIp = args[i + 1] as NSString
                if let ip = serverIp {
                    var socketAddr = sockaddr_in()
                    let ipCStr = ip.cString(using: String.Encoding.ascii.rawValue)
                    guard inet_pton(AF_INET, ipCStr!, &socketAddr.sin_addr) == 1 else {
                        throw ArgParserError.ServerIPError
                    }
                }
            } else if args[i] == "-d" {
                serverDir = args[i + 1]
            }
        }
        if targetFileNames.isEmpty && !server{
            throw ArgParserError.noFileNameFoundError
        }
        if serverIp == nil && !server{
            throw  ArgParserError.ServerIPError
        }
    }


}
