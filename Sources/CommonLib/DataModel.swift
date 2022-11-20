import Foundation

public enum ModelType: String, Codable{
    case SYN
    case ASK
}

public struct DataModel: Codable{
    
    public private (set) var type: ModelType
    public private (set) var data: String
    public private (set) var id: Int

    enum CodkingKeys: String, CodingKey {
        case data = "data"
        case type = "type"
        case id = "id"
    }

}
