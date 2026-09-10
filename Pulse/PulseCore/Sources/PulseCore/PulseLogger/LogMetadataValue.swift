/// Represents a structured metadata value in `PulseLogger` with built-in privacy classification.
///
/// Use `.public` for non-sensitive diagnostics and `.private` for confidential user data (e.g. tokens, emails).
/// When redaction is enabled, `.private` values are automatically replaced with `"***"`.
public enum LogMetadataValue: Sendable, Equatable, ExpressibleByStringLiteral, CustomStringConvertible, CustomDebugStringConvertible {
    /// Non-sensitive public diagnostic value that is rendered as-is across all environments.
    case `public`(String)
    
    /// Confidential or sensitive value that is redacted (`***`) in production environments or when redaction is enabled.
    case `private`(String)
    
    /// Initializes a public metadata value from a string literal.
    ///
    /// - Parameter value: The string value.
    public init(stringLiteral value: String) {
        self = .public(value)
    }
    
    /// The unredacted raw string representation of the metadata value.
    public var value: String {
        switch self {
        case .public(let val): return val
        case .private(let val): return val
        }
    }
    
    /// Returns the formatted string value, redacting sensitive content if `redacted` is true.
    ///
    /// - Parameter redacted: Whether sensitive values should be redacted to `"***"`. Defaults to `false`.
    /// - Returns: The rendered string value.
    public func rendered(redacted: Bool = false) -> String {
        switch self {
        case .public(let val): return val
        case .private(let val): return redacted ? "***" : val
        }
    }

    /// A textual description of the metadata value (rendered unredacted).
    public var description: String {
        return value
    }

    /// A debug representation showing both the privacy classification and value.
    public var debugDescription: String {
        switch self {
        case .public(let val): return "LogMetadataValue.public(\(val))"
        case .private(let val): return "LogMetadataValue.private(\(val))"
        }
    }
}
