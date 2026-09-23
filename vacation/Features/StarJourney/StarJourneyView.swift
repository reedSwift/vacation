import SwiftUI
import SwiftData

struct StarJourneyView: View {
    @Query private var stars: [DailyStar]
    @Query private var rewardUnlocks: [RewardUnlock]
    @State private var showTreasure = false

    private var rewardStatus: RewardJourneyStatus {
        RewardUnlocking.status(dailyStars: stars, rewardUnlocks: rewardUnlocks)
    }

    private var progress: StarJourneyProgress {
        StarJourneyProgress(total: stars.count, claimedRewardCycles: rewardStatus.totalRewardCyclesClaimed)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("My Star Journey ⭐")
                .font(.system(.title2, design: .rounded, weight: .bold))
                .accessibilityAddTraits(.isHeader)
            VStack(spacing: 18) {
                ViewThatFits(in: .horizontal) {
                    HStack(spacing: 2) { positions }
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 12) { positions }
                }
                HStack(spacing: 12) {
                    Image(systemName: "arrow.right")
                        .font(.title3.bold())
                        .accessibilityHidden(true)
                    if rewardStatus.isTreasureAvailable {
                        Button { showTreasure = true } label: {
                            Text("🎁").font(.system(size: 42))
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Open your surprise treasure")
                    } else {
                        Text("🎁").font(.system(size: 42))
                    }
                }
                Text(progress.message)
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)
            .padding(18)
            .background(LinearGradient(colors: [Color(red: 1, green: 0.97, blue: 0.83), .white.opacity(0.85)], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 28))
            #if DEBUG
            StarJourneyDebugControls()
            #endif
        }
        .sheet(isPresented: $showTreasure) {
            TreasureChestExperience()
                .presentationDragIndicator(.visible)
        }
    }

    @ViewBuilder private var positions: some View {
        ForEach(0..<7) { index in
            JourneyStar(position: index + 1, earned: index < progress.earned)
        }
    }
}

private struct JourneyStar: View {
    let position: Int
    let earned: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var taps = 0

    var body: some View {
        if earned {
            Button { taps += 1 } label: {
                icon.symbolEffect(.bounce, options: .nonRepeating, value: reduceMotion ? 0 : taps)
            }
            .buttonStyle(.plain)
            .sensoryFeedback(.selection, trigger: taps)
            .accessibilityLabel("Star \(position), earned")
            .accessibilityHint("Tap to make your star bounce.")
        } else {
            icon.accessibilityLabel("Star \(position), still to earn")
        }
    }

    private var icon: some View {
        Image(systemName: earned ? "star.fill" : "star")
            .font(.system(size: 31, weight: .medium))
            .foregroundStyle(earned ? Color(red: 0.95, green: 0.65, blue: 0.08) : Color(red: 0.6, green: 0.63, blue: 0.62))
            .shadow(color: earned ? .orange.opacity(0.2) : .clear, radius: 3, y: 2)
            .frame(width: 44, height: 48)
    }
}
