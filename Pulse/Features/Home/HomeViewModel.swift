import Foundation
import Combine

@MainActor
public final class HomeViewModel: ObservableObject {
    private let dependencyContainer: DependencyContainer
    
    @Published public var title: String = "Pulse Architecture Showcase"
    
    public init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
    }
}
