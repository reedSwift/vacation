import SwiftUI

struct MissionCard: View {
    let mission: DailyMission
    let isComplete: Bool
    let complete: () -> Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var celebration = false
    @State private var successCount = 0

    var body: some View {
        Button {
            guard !isComplete, complete() else { return }
            successCount += 1
            withAnimation(reduceMotion ? .easeInOut(duration: 0.2) : .spring(response: 0.35, dampingFraction: 0.6)) {
                celebration = true
            }
        } label: {
            HStack(spacing: 16) {
                if mission == .nightPants {
                    NightPantsIllustration()
                } else if mission == .bathTime {
                    Text(mission.emoji)
                        .font(.system(size: 34))
                        .frame(width: 60, height: 60)
                        .background(mission.tint.opacity(0.13), in: RoundedRectangle(cornerRadius: 20))
                } else {
                    BrushingMissionIllustration(isMorning: mission == .morningBrush, isComplete: isComplete)
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text(mission.name)
                        .font(.system(.title3, design: .rounded, weight: .bold))
                    Text(isComplete ? "You did it!" : "Tap when you’re done")
                        .font(.system(.subheadline, design: .rounded, weight: .medium))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: isComplete ? "checkmark.circle.fill" : "hand.tap.fill")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(Color(red: 0.08, green: 0.4, blue: 0.39))
                    .scaleEffect(celebration && !reduceMotion ? 1.15 : 1)
            }
            .foregroundStyle(Color(red: 0.08, green: 0.26, blue: 0.34))
            .padding(16)
            .background(isComplete ? Color(red: 0.85, green: 0.96, blue: 0.88) : .white.opacity(0.9), in: RoundedRectangle(cornerRadius: 28))
            .overlay { RoundedRectangle(cornerRadius: 28).stroke(isComplete ? Color.teal.opacity(0.25) : .white, lineWidth: 1) }
            .overlay {
                if celebration {
                    GeometryReader { geometry in
                        ForEach(0..<5) { index in
                            Image(systemName: "sparkle")
                                .font(.system(size: index.isMultiple(of: 2) ? 21 : 14, weight: .bold))
                                .foregroundStyle(Color(red: 0.76, green: 0.49, blue: 0.08))
                                .position(x: geometry.size.width * (0.08 + Double(index) * 0.21), y: index.isMultiple(of: 2) ? 5 : geometry.size.height - 5)
                        }
                    }
                    .transition(reduceMotion ? .opacity : .scale(scale: 0.7).combined(with: .opacity))
                    .allowsHitTesting(false)
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(isComplete)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(mission.name)
        .accessibilityValue(isComplete ? "Completed today" : "Ready to complete")
        .accessibilityHint(isComplete ? "" : "Double tap to complete today’s mission.")
        .sensoryFeedback(.impact(weight: .light), trigger: successCount)
        .animation(reduceMotion ? .easeInOut(duration: 0.2) : .spring(response: 0.35, dampingFraction: 0.7), value: isComplete)
        .task(id: successCount) {
            guard successCount > 0 else { return }
            do {
                try await Task.sleep(for: .milliseconds(750))
                withAnimation(.easeOut(duration: 0.2)) { celebration = false }
            } catch { }
        }
    }
}
