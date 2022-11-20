import Foundation

public enum ModelType: String, Codable{
    case SYN
    case ASK
}

public struct DataModel {
    
    public private (set) var type: ModelType
    public private (set) var data: String
    public private (set) var id: UInt

    public init(seq:UInt, type: Type, data: String) {
        self.id = seq
        self.type = type 
        self.data = data
    }

}

extension DataModel: Codable {

    enum CodkingKeys: String, CodingKey {
        case data = "data"
        case type = "type"
        case id = "id"
    }

}

extension DataModel: CustomStringConvertible {
    
    public var description: String {
        "SequenceNumber: \(id), \(type), Content: \(data)"
    }

}
