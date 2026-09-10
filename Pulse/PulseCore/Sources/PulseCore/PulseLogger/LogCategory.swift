import Foundation

/// A domain or subsystem identifier used to categorize log messages emitted by `PulseLogger`.
///
/// Categories allow organizing logs into functional areas such as Networking, UI, Database,
/// or Lifecycle. `LogCategory` conforms to `ExpressibleByStringLiteral` for easy inline declaration.
public struct LogCategory: Sendable, Hashable, ExpressibleByStringLiteral, CustomStringConvertible {
    /// The string identifier of the category.
    public let name: String
    
    /// Initializes a `LogCategory` with the specified category name.
    ///
    /// - Parameter name: The category name.
    public init(name: String) {
        self.name = name
    }
    
    /// Initializes a `LogCategory` from a string literal.
    ///
    /// - Parameter value: The string literal representing the category name.
    public init(stringLiteral value: String) {
        self.name = value
    }
    
    /// A textual representation of the category name.
    public var description: String {
        return name
    }
    
    /// The default category applied when no specific category is specified.
    public static let `default`: LogCategory = "Default"
    
    /// Category for network requests, responses, and socket traffic.
    public static let network: LogCategory = "Network"
    
    /// Category for user interface events, view lifecycle, and presentation.
    public static let ui: LogCategory = "UI"
    
    /// Category for persistent storage, Core Data, SQLite, and database operations.
    public static let database: LogCategory = "Database"
    
    /// Category for application and process lifecycle transitions.
    public static let lifecycle: LogCategory = "Lifecycle"
}
