import SwiftUI
import Combine

@MainActor
public final class AppCoordinator: ObservableObject {
    private let dependencyContainer: DependencyContainer
    @Published public var homeCoordinator: HomeCoordinator
    
    public init() {
        let container = DependencyContainer()
        self.dependencyContainer = container
        self.homeCoordinator = HomeCoordinator(dependencyContainer: container)
    }
    
    @ViewBuilder
    public func start() -> some View {
        homeCoordinator.start()
    }
}
