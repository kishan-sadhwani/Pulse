import XCTest
@testable import PulseCore

final class PulseLoggerTests: XCTestCase {
    func testLogLevelSymbols() {
        XCTAssertEqual(LogLevel.debug.symbol, "⚪️")
        XCTAssertEqual(LogLevel.info.symbol, "🔵")
        XCTAssertEqual(LogLevel.warning.symbol, "🟡")
        XCTAssertEqual(LogLevel.error.symbol, "🔴")
        XCTAssertEqual(LogLevel.fault.symbol, "💥")
    }

    func testLoggerAPIDoesNotCrash() {
        let logger = PulseLogger.shared
        logger.debug("Test debug message")
        logger.info("Test info message")
        logger.warning("Test warning message")
        logger.error("Test error message")
        logger.fault("Test fault message")
    }
    
    func testSharedLogger() {
        PulseLogger.shared.info("Shared logger test")
    }

    func testCategorizedLogger() {
        let networkLogger = PulseLogger.category(.network)
        XCTAssertEqual(networkLogger.category.name, "Network")
        networkLogger.info("Network request completed")
        
        let uiLogger = PulseLogger.category(.ui)
        XCTAssertEqual(uiLogger.category.name, "UI")
        uiLogger.debug("View appeared")
        
        let customLogger = PulseLogger.category("Custom")
        XCTAssertEqual(customLogger.category.name, "Custom")
        customLogger.warning("Custom category test")
    }

    func testPrivacyControls() {
        let publicVal: LogMetadataValue = "test"
        XCTAssertEqual(publicVal, .public("test"))
        XCTAssertEqual(publicVal.value, "test")
        XCTAssertEqual(publicVal.rendered(redacted: false), "test")
        XCTAssertEqual(publicVal.rendered(redacted: true), "test")
        
        let privateVal = LogMetadataValue.private("secret")
        XCTAssertEqual(privateVal.value, "secret")
        XCTAssertEqual(privateVal.rendered(redacted: false), "secret")
        XCTAssertEqual(privateVal.rendered(redacted: true), "***")
    }
    
    func testLoggerWithMetadata() {
        let logger = PulseLogger.shared
        logger.info("Test metadata", metadata: [
            "public_key": "public_value", // uses ExpressibleByStringLiteral
            "private_key": .private("secret_value")
        ] as [String: LogMetadataValue])
    }
}
