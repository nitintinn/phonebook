import SwiftUI

struct SplashScreenView: View {
    @State private var scale: CGFloat = 0.5
    @State private var isActive = false

    var body: some View {
        if isActive {
            CustomerListView()
        } else {
            VStack {
                Text("Nitin")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .scaleEffect(scale)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.5)) {
                            scale = 1.0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isActive = true
                        }
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
        }
    }
}
