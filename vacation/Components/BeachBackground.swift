import SwiftUI

struct BeachBackground: View {
    var body: some View {
        LinearGradient(
            colors: [Color(red: 0.77, green: 0.94, blue: 0.98),
                     Color(red: 0.94, green: 0.98, blue: 0.96),
                     Color(red: 1, green: 0.89, blue: 0.71)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }
}
