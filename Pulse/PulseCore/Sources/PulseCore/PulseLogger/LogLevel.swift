/// The severity level of a log message emitted by `PulseLogger`.
///
/// Log levels are ordered by severity from lowest (`.debug`) to highest (`.fault`),
/// and conform to `Comparable` allowing easy filtering against a minimum threshold.
public enum LogLevel: String, CaseIterable, Sendable, Comparable {
    /// Detailed diagnostic information intended for debugging during active development.
    case debug
    
    /// General informational messages about normal application flow and lifecycle events.
    case info
    
    /// Warning messages indicating non-fatal issues or unexpected conditions that should be noted.
    case warning
    
    /// Error messages indicating recoverable failures or issues that disrupted normal operation.
    case error
    
    /// Critical fault messages indicating severe, unrecoverable system failures or fatal state.
    case fault

    /// A visual emoji symbol representing the severity level in formatted log output.
    public var symbol: String {
        switch self {
        case .debug: return "⚪️"
        case .info: return "🔵"
        case .warning: return "🟡"
        case .error: return "🔴"
        case .fault: return "💥"
        }
    }

    private var priority: Int {
        switch self {
        case .debug: return 0
        case .info: return 1
        case .warning: return 2
        case .error: return 3
        case .fault: return 4
        }
    }

    /// Compares two log levels based on their severity priority.
    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        return lhs.priority < rhs.priority
    }
}

