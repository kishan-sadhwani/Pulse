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
        let logger = PulseLogger()
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
}
