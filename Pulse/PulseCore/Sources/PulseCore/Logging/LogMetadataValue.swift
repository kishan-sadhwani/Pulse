public enum LogMetadataValue: Sendable, Equatable, ExpressibleByStringLiteral {
    case `public`(String)
    case `private`(String)
    
    public init(stringLiteral value: String) {
        self = .public(value)
    }
    
    public var value: String {
        switch self {
        case .public(let val): return val
        case .private(let val): return val
        }
    }
    
    public func rendered(redacted: Bool = false) -> String {
        switch self {
        case .public(let val): return val
        case .private(let val): return redacted ? "***" : val
        }
    }
}
