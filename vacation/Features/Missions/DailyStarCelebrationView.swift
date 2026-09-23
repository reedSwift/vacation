import SwiftUI

struct DailyStarCelebrationView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var revealed = false

    var body: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.yellow.opacity(0.15))
                    .frame(width: 145, height: 145)
                ForEach(0..<5) { index in
                    Image(systemName: "sparkle")
                        .font(.system(size: index.isMultiple(of: 2) ? 17 : 11, weight: .bold))
                        .foregroundStyle(Color(red: 0.8, green: 0.49, blue: 0.08))
                        .offset(x: cos(Double(index) * .pi * 2 / 5) * 85,
                                y: sin(Double(index) * .pi * 2 / 5) * 70)
                        .opacity(revealed ? 1 : 0)
                }
                Image(systemName: "star.fill")
                    .font(.system(size: 112))
                    .foregroundStyle(LinearGradient(colors: [Color(red: 1, green: 0.87, blue: 0.32), Color(red: 1, green: 0.61, blue: 0.12)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .shadow(color: .orange.opacity(0.25), radius: 10, y: 5)
                    .rotationEffect(.degrees(reduceMotion || revealed ? 0 : -18))
                    .scaleEffect(reduceMotion || revealed ? 1 : 0.55)
                    .opacity(revealed ? 1 : 0)
            }
            .frame(height: 160)
            .accessibilityHidden(true)
            Text("⭐ You earned today’s star!")
                .font(.system(.title2, design: .rounded, weight: .bold))
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .padding(.horizontal, 12)
        .background(.white.opacity(0.65), in: RoundedRectangle(cornerRadius: 28))
        .task {
            guard !revealed else { return }
            withAnimation(reduceMotion ? .easeIn(duration: 0.25) : .spring(response: 0.6, dampingFraction: 0.6)) {
                revealed = true
            }
        }
    }
}
