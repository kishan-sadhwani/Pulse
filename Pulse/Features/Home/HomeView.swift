import SwiftUI

public struct HomeView: View {
    @ObservedObject private var viewModel: HomeViewModel
    
    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            Text("ᑭ")
                .font(.system(size: 60))
                .foregroundColor(.accentColor)
            
            Text(viewModel.title)
                .font(.title)
                .multilineTextAlignment(.center)
            
            Text("Minimal architectural baseline.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
