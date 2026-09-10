import Foundation

private final class LogEngineStore: @unchecked Sendable {
    private var lock = os_unfair_lock_s()
    private var _configuration: PulseLoggerConfiguration = PulseLoggerConfiguration()
    private var _providers: [any LogProvider] = [ConsoleLogProvider()]

    var configuration: PulseLoggerConfiguration {
        get {
            os_unfair_lock_lock(&lock)
            defer { os_unfair_lock_unlock(&lock) }
            return _configuration
        }
        set {
            os_unfair_lock_lock(&lock)
            defer { os_unfair_lock_unlock(&lock) }
            _configuration = newValue
        }
    }

    var providers: [any LogProvider] {
        get {
            os_unfair_lock_lock(&lock)
            defer { os_unfair_lock_unlock(&lock) }
            return _providers
        }
        set {
            os_unfair_lock_lock(&lock)
            defer { os_unfair_lock_unlock(&lock) }
            _providers = newValue
        }
    }

    func updateConfiguration(_ mutate: (inout PulseLoggerConfiguration) -> Void) {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }
        mutate(&_configuration)
    }

    func register(provider: any LogProvider) {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }
        _providers.append(provider)
    }

    func unregisterAllProviders() {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }
        _providers.removeAll()
    }

    func resetProviders() {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }
        _providers = [ConsoleLogProvider()]
    }

    func reset() {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }
        _configuration = PulseLoggerConfiguration()
        _providers = [ConsoleLogProvider()]
    }
}

private let engineStore = LogEngineStore()

public struct PulseLogger: Sendable {
    public static let shared = PulseLogger()

    public let category: LogCategory

    /// The current active configuration for `PulseLogger`.
    public static var configuration: PulseLoggerConfiguration {
        get { engineStore.configuration }
    }

    /// Mutates the centralized runtime configuration for `PulseLogger`.
    public static func configure(_ mutate: (inout PulseLoggerConfiguration) -> Void) {
        engineStore.updateConfiguration(mutate)
    }

    /// Sets the centralized configuration for `PulseLogger`.
    public static func configure(with configuration: PulseLoggerConfiguration) {
        engineStore.configuration = configuration
    }

    /// Resets configuration and providers back to default settings.
    public static func resetConfiguration() {
        engineStore.reset()
    }

    // MARK: - Provider Management

    /// The list of currently active log providers.
    public static var providers: [any LogProvider] {
        get { engineStore.providers }
    }

    /// Registers an additional log provider to receive log events.
    public static func register(_ provider: any LogProvider) {
        engineStore.register(provider: provider)
    }

    /// Registers an additional log provider to receive log events.
    public static func register(provider: any LogProvider) {
        engineStore.register(provider: provider)
    }

    /// Sets the list of active log providers.
    public static func setProviders(_ providers: [any LogProvider]) {
        engineStore.providers = providers
    }

    /// Unregisters all active log providers.
    public static func unregisterAllProviders() {
        engineStore.unregisterAllProviders()
    }

    /// Resets the registered providers to the default provider set (`[ConsoleLogProvider()]`).
    public static func resetProviders() {
        engineStore.resetProviders()
    }

    // MARK: - Initialization

    private init(category: LogCategory = .default) {
        self.category = category
    }

    public static func category(_ category: LogCategory) -> PulseLogger {
        return PulseLogger(category: category)
    }

    // MARK: - Logging APIs

    public func debug(_ message: String, metadata: [String: LogMetadataValue]? = nil) {
        log(level: .debug, message: message, metadata: metadata)
    }

    public func info(_ message: String, metadata: [String: LogMetadataValue]? = nil) {
        log(level: .info, message: message, metadata: metadata)
    }

    public func warning(_ message: String, metadata: [String: LogMetadataValue]? = nil) {
        log(level: .warning, message: message, metadata: metadata)
    }

    public func error(_ message: String, metadata: [String: LogMetadataValue]? = nil, error: Swift.Error? = nil, file: String = #file, line: UInt = #line) {
        log(level: .error, message: message, metadata: metadata, error: error, file: file, line: line)
    }

    public func fault(_ message: String, metadata: [String: LogMetadataValue]? = nil, error: Swift.Error? = nil, file: String = #file, line: UInt = #line) {
        log(level: .fault, message: message, metadata: metadata, error: error, file: file, line: line)
    }

    @discardableResult
    internal func log(
        level: LogLevel,
        message: String,
        metadata: [String: LogMetadataValue]? = nil,
        error: Swift.Error? = nil,
        file: String? = nil,
        line: UInt? = nil
    ) -> String? {
        let config = PulseLogger.configuration

        guard config.isEnabled else {
            return nil
        }

        guard level >= config.minimumLevel else {
            return nil
        }

        let activeProviders = PulseLogger.providers
        for provider in activeProviders {
            provider.log(
                level: level,
                message: message,
                category: category,
                metadata: metadata,
                error: error,
                file: file,
                line: line
            )
        }

        return ConsoleLogProvider().format(
            level: level,
            message: message,
            category: category,
            metadata: metadata,
            error: error,
            file: file,
            line: line,
            configuration: config
        )
    }
}
