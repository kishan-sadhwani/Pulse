import Testing
import Foundation
@testable import PulseCore

@Suite("PulseLogger Tests", .serialized)
struct PulseLoggerTests {
    init() {
        PulseLogger.resetConfiguration()
    }

    @Test("Log level symbol mapping")
    func logLevelSymbols() {
        #expect(LogLevel.debug.symbol == "⚪️")
        #expect(LogLevel.info.symbol == "🔵")
        #expect(LogLevel.warning.symbol == "🟡")
        #expect(LogLevel.error.symbol == "🔴")
        #expect(LogLevel.fault.symbol == "💥")
    }

    @Test("Log level comparability and ordering")
    func logLevelComparison() {
        #expect(LogLevel.debug < LogLevel.info)
        #expect(LogLevel.info < LogLevel.warning)
        #expect(LogLevel.warning < LogLevel.error)
        #expect(LogLevel.error < LogLevel.fault)
        
        #expect(LogLevel.fault > LogLevel.debug)
        #expect(LogLevel.info >= LogLevel.info)
    }

    @Test("Default configuration values")
    func defaultConfiguration() {
        let config = PulseLogger.configuration
        #expect(config.minimumLevel == .debug)
        #expect(config.isEnabled == true)
        #expect(config.showEmoji == false)
        #expect(config.showCategory == true)
        #expect(config.showTimestamp == false)
        #expect(config.showCallerInfo == true)
        #expect(config.isRedacted == nil)
    }

    @Test("Configure with mutation closure")
    func configureBlock() {
        PulseLogger.configure {
            $0.minimumLevel = .warning
            $0.isEnabled = false
            $0.showEmoji = true
        }
        
        let config = PulseLogger.configuration
        #expect(config.minimumLevel == .warning)
        #expect(config.isEnabled == false)
        #expect(config.showEmoji == true)
    }

    @Test("Configure with explicit configuration instance")
    func configureWithInstance() {
        let customConfig = PulseLoggerConfiguration(
            minimumLevel: .error,
            isEnabled: true,
            showEmoji: true,
            showCategory: false,
            showTimestamp: true,
            showCallerInfo: false,
            isRedacted: true
        )
        PulseLogger.configure(with: customConfig)
        
        #expect(PulseLogger.configuration == customConfig)
    }

    @Test("Reset configuration to defaults")
    func resetConfiguration() {
        PulseLogger.configure {
            $0.minimumLevel = .fault
            $0.isEnabled = false
        }
        #expect(PulseLogger.configuration.isEnabled == false)
        
        PulseLogger.resetConfiguration()
        #expect(PulseLogger.configuration.isEnabled == true)
        #expect(PulseLogger.configuration.minimumLevel == .debug)
    }

    @Test("Minimum level filtering")
    func minimumLevelFiltering() {
        PulseLogger.configure {
            $0.minimumLevel = .warning
        }
        
        let logger = PulseLogger.shared
        // Below minimum level (.debug and .info) should return nil
        #expect(logger.log(level: .debug, message: "Ignored debug") == nil)
        #expect(logger.log(level: .info, message: "Ignored info") == nil)
        
        // At or above minimum level should produce output
        #expect(logger.log(level: .warning, message: "Handled warning") != nil)
        #expect(logger.log(level: .error, message: "Handled error") != nil)
        #expect(logger.log(level: .fault, message: "Handled fault") != nil)
    }

    @Test("Logging disabled globally")
    func loggingDisabled() {
        PulseLogger.configure {
            $0.isEnabled = false
        }
        
        let logger = PulseLogger.shared
        #expect(logger.log(level: .fault, message: "Ignored fault when disabled") == nil)
        #expect(logger.log(level: .debug, message: "Ignored debug when disabled") == nil)
    }

    @Test("Formatting options: emoji, category, caller info")
    func formattingOptions() {
        PulseLogger.configure {
            $0.showEmoji = true
            $0.showCategory = false
            $0.showCallerInfo = false
        }
        
        let logger = PulseLogger.category(.network)
        let output = logger.log(level: .info, message: "Test formatted message", file: "File.swift", line: 42)
        
        guard let output = output else {
            #expect(Bool(false), "Output should not be nil")
            return
        }
        
        // Category should be hidden
        #expect(!output.contains("[Network]"))
        // Emoji should be included
        #expect(output.contains("[INFO 🔵]"))
        // Caller info should be hidden
        #expect(!output.contains("[File.swift:42]"))
        #expect(output.contains("Test formatted message"))
    }

    @Test("Explicit redaction configuration override")
    func explicitRedactionConfiguration() {
        PulseLogger.configure {
            $0.isRedacted = true
        }
        
        let logger = PulseLogger.shared
        let output = logger.log(
            level: .info,
            message: "User action",
            metadata: ["secret": .private("my-password")]
        )
        
        #expect(output != nil)
        #expect(output?.contains("***") == true)
        #expect(output?.contains("my-password") == false)
    }

    @Test("Public logging APIs execution")
    func loggerAPIDoesNotCrash() {
        let logger = PulseLogger.shared
        logger.debug("Test debug message")
        logger.info("Test info message")
        logger.warning("Test warning message")
        logger.error("Test error message")
        logger.fault("Test fault message")
    }

    @Test("Categorized loggers")
    func categorizedLogger() {
        let networkLogger = PulseLogger.category(.network)
        #expect(networkLogger.category.name == "Network")
        networkLogger.info("Network request completed")
        
        let uiLogger = PulseLogger.category(.ui)
        #expect(uiLogger.category.name == "UI")
        uiLogger.debug("View appeared")
        
        let customLogger = PulseLogger.category("Custom")
        #expect(customLogger.category.name == "Custom")
        customLogger.warning("Custom category test")
    }

    @Test("Privacy controls data classification")
    func privacyControls() {
        let publicVal: LogMetadataValue = "test"
        #expect(publicVal == .public("test"))
        #expect(publicVal.value == "test")
        #expect(publicVal.rendered(redacted: false) == "test")
        #expect(publicVal.rendered(redacted: true) == "test")
        
        let privateVal = LogMetadataValue.private("secret")
        #expect(privateVal.value == "secret")
        #expect(privateVal.rendered(redacted: false) == "secret")
        #expect(privateVal.rendered(redacted: true) == "***")
    }

    @Test("Logging with metadata dictionary")
    func loggerWithMetadata() {
        let logger = PulseLogger.shared
        logger.info("Test metadata", metadata: [
            "public_key": "public_value",
            "private_key": .private("secret_value")
        ])
    }

    @Test("Thread-safe concurrent configuration access and mutation")
    func threadSafeConfiguration() {
        let iterations = 1_000
        DispatchQueue.concurrentPerform(iterations: iterations) { i in
            if i % 2 == 0 {
                PulseLogger.configure {
                    $0.minimumLevel = (i % 4 == 0) ? .debug : .error
                }
            } else {
                _ = PulseLogger.configuration.minimumLevel
                PulseLogger.shared.debug("Concurrent test message \(i)")
            }
        }
    }
}


