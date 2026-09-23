import SwiftUI
import SwiftData

struct TreasuresPreviewView: View {
    @Query(sort: \RewardUnlock.unlockedAt) private var rewardUnlocks: [RewardUnlock]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("My Treasures ✨")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .accessibilityAddTraits(.isHeader)
                Spacer()
                Text("See All")
                    .font(.system(.headline, design: .rounded, weight: .bold))
                    .foregroundStyle(Color(red: 0.06, green: 0.45, blue: 0.5))
            }

            HStack(spacing: 10) {
                ForEach(RewardCatalog.rewards.prefix(4)) { reward in
                    MiniTreasurePreviewCard(
                        reward: reward,
                        isUnlocked: TreasureCollection.isUnlocked(reward, unlocks: rewardUnlocks)
                    )
                }
            }
        }
        .padding(18)
        .background(
            LinearGradient(
                colors: [Color(red: 1, green: 0.93, blue: 0.72), .white.opacity(0.88)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 28)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("My Treasures. See all treasures.")
    }
}

private struct MiniTreasurePreviewCard: View {
    let reward: RewardDefinition
    let isUnlocked: Bool

    var body: some View {
        Text(isUnlocked ? reward.visualIdentifier : "❓")
            .font(.system(size: 34))
            .frame(maxWidth: .infinity, minHeight: 70)
            .background(
                isUnlocked
                ? LinearGradient(colors: [Color.yellow.opacity(0.42), Color.white.opacity(0.9)], startPoint: .top, endPoint: .bottom)
                : LinearGradient(colors: [Color.white.opacity(0.72), Color(red: 0.78, green: 0.93, blue: 0.94).opacity(0.58)], startPoint: .top, endPoint: .bottom),
                in: RoundedRectangle(cornerRadius: 22)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 22)
                    .stroke(isUnlocked ? Color.orange.opacity(0.35) : Color.white.opacity(0.55), lineWidth: 2)
            }
            .shadow(color: isUnlocked ? .orange.opacity(0.12) : .clear, radius: 5, y: 3)
            .accessibilityLabel(isUnlocked ? "\(reward.displayName), unlocked" : "Mystery Treasure, locked")
    }
}
