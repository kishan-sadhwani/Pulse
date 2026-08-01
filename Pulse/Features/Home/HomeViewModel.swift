import Foundation
import Combine
import PulseCore

@MainActor
public final class HomeViewModel: ObservableObject {
    private let dependencyContainer: DependencyContainer
    
    @Published public var title: String = "Pulse Architecture Showcase"
    
    let logger = PulseLogger.category(.network)
    
    public init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
        PulseLogger.shared.debug("REPORTING DEBUG")
        PulseLogger.shared.warning("REPORTING WARNING")
        PulseLogger.shared.fault("REPORTING FAULT")
        
        logger.error("REPORTING ERROR")
        logger.info("REPORTING INFO")
        
    }
}
