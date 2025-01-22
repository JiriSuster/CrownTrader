import SwiftUI

struct LoadingView: View {
    @State private var isLoading = false

    var body: some View {
        
        Image(systemName: "crown.fill")
            .foregroundColor(.green)
            .font(.system(size: 80))
            .frame(width: 80, height: 80)
            .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
            .animation(.linear(duration: 1.5).repeatForever(autoreverses: false), value: isLoading)
            .onAppear() {
                self.isLoading = true
            }
            .padding(30)
            .background(.ultraThinMaterial)
            .cornerRadius(25)
    }
}

#Preview {
    ZStack {
        Color.gray

        LoadingView()
    }
    .ignoresSafeArea()
}

