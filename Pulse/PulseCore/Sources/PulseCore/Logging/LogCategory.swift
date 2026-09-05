import Foundation

public struct LogCategory: Sendable, Hashable, ExpressibleByStringLiteral, CustomStringConvertible {
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
    
    public init(stringLiteral value: String) {
        self.name = value
    }
    
    public var description: String {
        return name
    }
    
    public static let `default`: LogCategory = "Default"
    public static let network: LogCategory = "Network"
    public static let ui: LogCategory = "UI"
    public static let database: LogCategory = "Database"
    public static let lifecycle: LogCategory = "Lifecycle"
}
