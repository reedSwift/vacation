import SwiftUI
import SwiftData

struct MyTreasuresView: View {
    @Query(sort: \RewardUnlock.unlockedAt) private var rewardUnlocks: [RewardUnlock]
    private let columns = [GridItem(.adaptive(minimum: 148), spacing: 16)]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("My Treasures ✨")
                        .font(.system(.largeTitle, design: .rounded, weight: .heavy))
                        .accessibilityAddTraits(.isHeader)
                    Text("Look at everything you’ve earned! ⭐")
                        .font(.system(.title3, design: .rounded, weight: .semibold))
                }
                .padding(.top, 20)

                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(RewardCatalog.rewards) { reward in
                        TreasureCollectionCard(
                            reward: reward,
                            isUnlocked: TreasureCollection.isUnlocked(reward, unlocks: rewardUnlocks)
                        )
                    }
                }
            }
            .foregroundStyle(Color(red: 0.08, green: 0.26, blue: 0.34))
            .padding(.horizontal, 20)
            .padding(.bottom, 28)
            .frame(maxWidth: 620)
            .frame(maxWidth: .infinity)
        }
        .background { BeachBackground() }
        .navigationTitle("My Treasures")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct TreasureCollectionCard: View {
    let reward: RewardDefinition
    let isUnlocked: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var taps = 0

    var body: some View {
        Group {
            if isUnlocked {
                Button { taps += 1 } label: {
                    cardContent
                }
                .buttonStyle(.plain)
                .sensoryFeedback(.selection, trigger: taps)
                .accessibilityLabel("\(reward.displayName), unlocked treasure")
                .accessibilityHint("Tap to make your treasure sparkle.")
            } else {
                cardContent
                    .accessibilityLabel("Mystery Treasure, locked")
            }
        }
    }

    private var cardContent: some View {
        VStack(spacing: 12) {
            ZStack {
                if isUnlocked {
                    ForEach(0..<5) { index in
                        Image(systemName: "sparkle")
                            .font(.system(size: index.isMultiple(of: 2) ? 15 : 11, weight: .bold))
                            .foregroundStyle(index.isMultiple(of: 2) ? Color.yellow : Color.orange)
                            .offset(
                                x: cos(Double(index) * 1.25) * (reduceMotion ? 34 : 42),
                                y: sin(Double(index) * 1.25) * (reduceMotion ? 30 : 38)
                            )
                            .opacity(0.85)
                    }
                }
                Text(isUnlocked ? reward.visualIdentifier : "❓")
                    .font(.system(size: 58))
                    .scaleEffect(!reduceMotion && isUnlocked && taps.isMultiple(of: 2) ? 1.0 : 1.08)
                    .rotationEffect(.degrees(!reduceMotion && isUnlocked && taps > 0 ? 4 : 0))
                    .symbolEffect(.bounce, options: .nonRepeating, value: reduceMotion ? 0 : taps)
                    .accessibilityHidden(true)
            }
            .frame(height: 88)

            Text(isUnlocked ? reward.displayName : "Mystery Treasure")
                .font(.system(.headline, design: .rounded, weight: .heavy))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, minHeight: 176)
        .padding(16)
        .background(background, in: RoundedRectangle(cornerRadius: 28))
        .overlay {
            RoundedRectangle(cornerRadius: 28)
                .stroke(isUnlocked ? Color.orange.opacity(0.36) : Color.white.opacity(0.7), lineWidth: 2)
        }
        .shadow(color: isUnlocked ? .orange.opacity(0.16) : .black.opacity(0.04), radius: isUnlocked ? 12 : 5, y: isUnlocked ? 8 : 3)
        .animation(.spring(response: 0.35, dampingFraction: 0.58), value: taps)
    }

    private var background: LinearGradient {
        if isUnlocked {
            LinearGradient(
                colors: [Color(red: 1, green: 0.87, blue: 0.36), Color.white.opacity(0.9), Color(red: 0.78, green: 0.96, blue: 0.96).opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            LinearGradient(
                colors: [Color.white.opacity(0.72), Color(red: 0.79, green: 0.92, blue: 0.96).opacity(0.72)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}
