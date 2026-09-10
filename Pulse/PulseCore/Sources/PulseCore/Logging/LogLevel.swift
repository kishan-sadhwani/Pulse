public enum LogLevel: String, CaseIterable, Sendable, Comparable {
    case debug
    case info
    case warning
    case error
    case fault

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

    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        return lhs.priority < rhs.priority
    }
}

