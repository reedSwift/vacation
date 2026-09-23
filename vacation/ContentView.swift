import SwiftUI

struct ContentView: View {
    @AppStorage("hasOpenedSurprise") private var hasOpenedSurprise = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            BeachBackground()
            if hasOpenedSurprise {
                KidsHomeView(onReplaySurprise: { hasOpenedSurprise = false })
                    .transition(.opacity)
            } else {
                SurpriseRevealView {
                    withAnimation(.easeInOut(duration: reduceMotion ? 0.25 : 0.4)) {
                        hasOpenedSurprise = true
                    }
                }
                .transition(.opacity)
            }
        }
    }
}

#Preview {
    ContentView()
}
