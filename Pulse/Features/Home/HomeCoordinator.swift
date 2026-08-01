import SwiftUI
import Combine

@MainActor
public final class HomeCoordinator: ObservableObject {
    private let dependencyContainer: DependencyContainer
    @Published public var viewModel: HomeViewModel
    
    public init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
        self.viewModel = HomeViewModel(dependencyContainer: dependencyContainer)
    }
    
    @ViewBuilder
    public func start() -> some View {
        HomeView(viewModel: viewModel)
    }
}
