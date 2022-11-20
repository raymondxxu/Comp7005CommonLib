import Foundation

public enum ModelType: String, Codable{
    case SYN
    case ASK
}

protocol JsonStringConvertible {
    
    func convert(from json: String) -> JsonStringConvertible?
    func convert() -> String? 

}

public struct DataModel {
    
    public private (set) var type: ModelType
    public private (set) var data: String?
    public private (set) var id: UInt

    public init(seq:UInt, type: ModelType, data: String?) {
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
        "SequenceNumber: \(id), \(type), Content: \(data ?? "")"
    }

}

extension DataModel: JsonStringConvertible {
    
    func convert(from json: String) -> JsonStringConvertible? {
        let decoder = JSONDecoder()
        return try? decoder.decode(DataModel.self, from: Data(json.utf8))
    }

    func convert() -> String? {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(self)
        guard let data = data else { return nil }
        return String(data: data, encoding: .utf8)
    }

}
