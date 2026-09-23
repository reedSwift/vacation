import SwiftUI
import SwiftData

struct TreasureChestExperience: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var phase = TreasurePhase.closed
    @State private var appeared = false
    @State private var isClaiming = false
    @State private var claimedReward: RewardDefinition?
    @State private var saveFailed = false

    var body: some View {
        ZStack {
            BeachBackground()
            TreasureSparkles(isOpen: phase == .open)
            if phase == .open {
                CelebrationConfetti()
            }
            ScrollView {
                VStack(spacing: 22) {
                    title
                    TreasureChestIllustration(isOpen: phase == .open)
                        .frame(width: 330, height: 280)
                        .padding(.top, phase == .open ? 0 : 8)
                    content
                }
                .multilineTextAlignment(.center)
                .foregroundStyle(Color(red: 0.08, green: 0.26, blue: 0.34))
                .padding(28)
                .padding(.top, 34)
                .frame(maxWidth: 520)
                .frame(maxWidth: .infinity)
            }
        }
        .task {
            withAnimation(reduceMotion ? .easeIn(duration: 0.2) : .spring(response: 0.6, dampingFraction: 0.72)) {
                appeared = true
            }
        }
        .sensoryFeedback(.success, trigger: phase == .open)
        .alert("Let’s try again", isPresented: $saveFailed) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("We couldn’t open the treasure just now. Please tap again in a moment.")
        }
    }

    private var title: some View {
        VStack(spacing: 10) {
            Text(phase == .open ? "YOU UNLOCKED!" : "✨ Something magical happened… ✨")
                .font(.system(.largeTitle, design: .rounded, weight: .heavy))
                .accessibilityAddTraits(.isHeader)
            if phase == .closed {
                Text("You collected 7 stars!")
                    .font(.system(.title2, design: .rounded, weight: .bold))
            }
        }
        .scaleEffect(appeared || reduceMotion ? 1 : 0.92)
        .opacity(appeared ? 1 : 0)
    }

    @ViewBuilder private var content: some View {
        if phase == .closed {
            Button("OPEN MY SURPRISE") { openTreasure() }
                .font(.system(.title2, design: .rounded, weight: .heavy))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, minHeight: 76)
                .background(
                    LinearGradient(colors: [Color(red: 0.95, green: 0.42, blue: 0.36), Color(red: 0.98, green: 0.67, blue: 0.25)], startPoint: .leading, endPoint: .trailing),
                    in: RoundedRectangle(cornerRadius: 28)
                )
                .shadow(color: .orange.opacity(0.22), radius: 14, y: 8)
                .buttonStyle(.plain)
                .disabled(isClaiming)
                .opacity(isClaiming ? 0.7 : 1)
                .accessibilityHint("Open the treasure chest to reveal your surprise.")
        } else if let reward = claimedReward {
            VStack(spacing: 10) {
                Text(reward.visualIdentifier)
                    .font(.system(size: 96))
                    .symbolEffect(.bounce, options: .nonRepeating, value: phase)
                    .accessibilityHidden(true)
                Text(reward.displayName)
                    .font(.system(.largeTitle, design: .rounded, weight: .heavy))
                Button("YAY!") { dismiss() }
                    .font(.system(.title2, design: .rounded, weight: .heavy))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 72)
                    .background(Color(red: 0.09, green: 0.37, blue: 0.39), in: RoundedRectangle(cornerRadius: 26))
                    .buttonStyle(.plain)
                    .padding(.top, 10)
            }
            .transition(reduceMotion ? .opacity : .scale.combined(with: .opacity))
        }
    }

    private func openTreasure() {
        guard !isClaiming, phase == .closed else { return }
        isClaiming = true
        do {
            guard let unlock = try RewardUnlocking.claimNextAvailableReward(in: context) else {
                isClaiming = false
                dismiss()
                return
            }
            try context.save()
            claimedReward = RewardCatalog.reward(forCycle: unlock.cycleNumber)
            withAnimation(reduceMotion ? .easeInOut(duration: 0.25) : .spring(response: 0.7, dampingFraction: 0.68)) {
                phase = .open
            }
            isClaiming = false
        } catch {
            context.rollback()
            isClaiming = false
            saveFailed = true
        }
    }
}

private enum TreasurePhase {
    case closed
    case open
}

private struct TreasureChestIllustration: View {
    let isOpen: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var wiggle = false

    var body: some View {
        ZStack {
            light
            Image("TreasureChestClosed")
                .resizable()
                .scaledToFit()
                .opacity(isOpen ? 0 : 1)
                .scaleEffect(isOpen ? 0.92 : 1)
            Image("TreasureChestOpen")
                .resizable()
                .scaledToFit()
                .opacity(isOpen ? 1 : 0)
                .scaleEffect(isOpen ? 1.06 : 0.86)
        }
        .shadow(color: .orange.opacity(isOpen ? 0.24 : 0.14), radius: isOpen ? 18 : 10, y: 8)
        .rotationEffect(.degrees(!isOpen && wiggle && !reduceMotion ? -2 : 2))
        .scaleEffect(isOpen && !reduceMotion ? 1.04 : 1)
        .task {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 0.92).repeatForever(autoreverses: true)) {
                wiggle = true
            }
        }
        .accessibilityLabel(isOpen ? "Open treasure chest" : "Closed glowing treasure chest")
    }

    private var light: some View {
        ZStack {
            Circle()
                .fill(Color.yellow.opacity(isOpen ? 0.36 : 0.2))
                .blur(radius: 20)
                .frame(width: isOpen ? 300 : 210, height: isOpen ? 300 : 150)
                .offset(y: isOpen ? -56 : -18)
            ForEach(0..<10) { index in
                Capsule()
                    .fill(Color.yellow.opacity(isOpen ? 0.36 : 0.16))
                    .frame(width: 11, height: isOpen ? 170 : 78)
                    .rotationEffect(.degrees(Double(index) * 20 - 90))
                    .offset(y: isOpen ? -62 : -34)
            }
        }
    }
}

private struct TreasureSparkles: View {
    let isOpen: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var float = false

    var body: some View {
        TimelineView(.animation(minimumInterval: reduceMotion ? 1 : 1 / 24)) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                for index in 0..<22 {
                    let phase = Double(index) * 0.73
                    let radius = isOpen ? 148.0 : 108.0
                    let x = size.width / 2 + cos(time * 0.45 + phase) * radius * (0.35 + Double(index % 4) * 0.18)
                    let y = size.height * 0.36 + sin(time * 0.55 + phase) * radius * 0.42 - (isOpen ? 44 : 0)
                    let side = CGFloat(index.isMultiple(of: 3) ? 10 : 6)
                    let rect = CGRect(x: x, y: y, width: side, height: side)
                    context.fill(Path(ellipseIn: rect), with: .color(index.isMultiple(of: 2) ? .yellow.opacity(0.62) : .white.opacity(0.78)))
                }
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}
