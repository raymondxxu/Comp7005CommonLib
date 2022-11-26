//
// Created by Raymond Xu on 2022-10-02.
//

import Foundation
import Socket

public enum ArgParserError: Error {
    case PortNumberError
    case SenderIPError
    case missingSenderIPError
    case receiverIPError
    case missingReceiverIPError
    case noFileNameFoundError
    case receiverPortNumberError
}

fileprivate enum ProgramType {
    case sender
    case receiver
    case proxy
}

public class ArgParser {

    public private(set) var receiverPortNumber: UInt16?
    public private(set) var portNumber: UInt16?
    public private(set) var senderIp: NSString?
    public private(set) var receiverIp: NSString?
    public private(set) var targetFileNames: Set<String>
    private var type: ProgramType

    public static let senderArgParser = ArgParser(type: .sender)
    public static let receiverArgParser = ArgParser(type: .receiver)
    public static let proxyArgParser = ArgParser(type: .proxy)

    private init(type: ProgramType) {
        self.type = type
        targetFileNames = Set<String>()
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
             } .forEach {
                targetFileNames.insert($0)
            }
        }


        for i in 0..<args.count {
            //CommandLine arguments for port number
            if args[i] == "-p" {
                if let pn = UInt16(args[i + 1]) {
                    portNumber = pn
                } else {
                    throw ArgParserError.PortNumberError
                }
            } else if args[i] == "-rp" {
                if let pn = UInt16(args[i + 1]) {
                    receiverPortNumber = pn
                } else {
                    throw ArgParserError.PortNumberError
                }
            } else if args[i] == "-s" { //CommandLine arguments for senderIp
                senderIp = args[i + 1] as NSString
                if let ip = senderIp {
                    var socketAddr = sockaddr_in()
                    let ipCStr = ip.cString(using: String.Encoding.ascii.rawValue)
                    guard inet_pton(AF_INET, ipCStr!, &socketAddr.sin_addr) == 1 else {
                        throw ArgParserError.SenderIPError
                    }
                }
            } else if args[i] == "-r" { //CommandLine arguments for rec'
                receiverIp = args[i + 1] as NSString
                if let ip = receiverIp {
                    var socketAddr = sockaddr_in()
                    let ipCStr = ip.cString(using: String.Encoding.ascii.rawValue)
                    guard inet_pton(AF_INET, ipCStr!, &socketAddr.sin_addr) == 1 else {
                        throw ArgParserError.receiverIPError
                    }
                }

            }
        }
        switch type {
            case .sender:
                if receiverIp == nil {
                    throw ArgParserError.missingSenderIPError
                }
                if portNumber == nil {
                    throw ArgParserError.PortNumberError
                }
            case .receiver:
                if portNumber == nil {
                    throw ArgParserError.PortNumberError
                }
            case .proxy:
                if portNumber == nil {
                    throw ArgParserError.PortNumberError
                }
                if receiverPortNumber == nil {
                    throw ArgParserError.receiverPortNumberError
                }
                if receiverIp == nil {
                    throw ArgParserError.missingSenderIPError
                }
            
        }
    }


}
