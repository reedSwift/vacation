import SwiftUI

struct DailyMissionCelebration: View {
    let earnedNewStar: Bool
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.scenePhase) private var scenePhase
    @State private var appeared = false
    @State private var starsFloat = false
    @State private var sound = CelebrationSound()
    @AccessibilityFocusState private var titleFocused: Bool

    var body: some View {
        ZStack {
            BeachBackground()
            ScrollView {
                VStack(spacing: 24) {
                    Text("Olivia, you did it!")
                        .font(.system(.largeTitle, design: .rounded, weight: .heavy))
                        .accessibilityAddTraits(.isHeader)
                        .accessibilityFocused($titleFocused)
                    if earnedNewStar {
                        DailyStarCelebrationView()
                    }
                    sunshine
                    Text("You took care of yourself today!")
                        .font(.system(.title2, design: .rounded, weight: .semibold))
                    Text("All four missions are done.")
                        .font(.system(.body, design: .rounded))
                    Button("YAY!") { dismiss() }
                        .font(.system(.title2, design: .rounded, weight: .heavy))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, minHeight: 72)
                        .background(Color(red: 0.09, green: 0.37, blue: 0.39), in: RoundedRectangle(cornerRadius: 26))
                        .buttonStyle(.plain)
                        .accessibilityHint("Return to your completed missions.")
                }
                .multilineTextAlignment(.center)
                .foregroundStyle(Color(red: 0.08, green: 0.26, blue: 0.34))
                .padding(28)
                .padding(.top, 30)
                .frame(maxWidth: 500)
                .frame(maxWidth: .infinity)
            }
        }
        .overlay { CelebrationConfetti() }
        .sensoryFeedback(.success, trigger: appeared)
        .task {
            titleFocused = true
            sound.play()
            withAnimation(reduceMotion ? .easeIn(duration: 0.25) : .spring(response: 0.55, dampingFraction: 0.65)) {
                appeared = true
            }
            withAnimation(.easeOut(duration: 3)) { starsFloat = true }
        }
        .onDisappear { sound.stop() }
        .onChange(of: scenePhase) { _, phase in
            if phase != .active { sound.stop() }
        }
    }

    private var sunshine: some View {
        ZStack {
            ForEach(0..<10) { index in
                Image(systemName: index.isMultiple(of: 3) ? "circle" : "sparkle")
                    .font(.system(size: index.isMultiple(of: 2) ? 20 : 13, weight: .bold))
                    .foregroundStyle(index.isMultiple(of: 2) ? Color.teal : Color.orange)
                    .offset(x: cos(Double(index) * .pi / 5) * (starsFloat && !reduceMotion ? 135 : 100),
                            y: sin(Double(index) * .pi / 5) * (starsFloat && !reduceMotion ? 130 : 90))
                    .opacity(starsFloat ? 0 : 0.9)
            }
            Image(systemName: "sun.max.fill")
                .font(.system(size: 185))
                .foregroundStyle(LinearGradient(colors: [Color(red: 1, green: 0.83, blue: 0.3), Color(red: 1, green: 0.62, blue: 0.2)], startPoint: .top, endPoint: .bottom))
                .shadow(color: .orange.opacity(0.15), radius: 16, y: 8)
            VStack(spacing: 12) {
                HStack(spacing: 28) {
                    Capsule().frame(width: 6, height: 10)
                    Capsule().frame(width: 6, height: 10)
                }
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addQuadCurve(to: CGPoint(x: 30, y: 0), control: CGPoint(x: 15, y: 22))
                }
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: 30, height: 14)
            }
            .foregroundStyle(Color(red: 0.48, green: 0.26, blue: 0.11))
        }
        .frame(width: 280, height: 280)
        .scaleEffect(appeared || reduceMotion ? 1 : 0.7)
        .opacity(appeared ? 1 : 0)
        .accessibilityHidden(true)
    }
}
