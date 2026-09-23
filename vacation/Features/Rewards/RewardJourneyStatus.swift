import Foundation
import SwiftData

struct RewardJourneyStatus: Equatable {
    static let starsPerReward = 7

    let totalDailyStars: Int
    let claimedCycleNumbers: Set<Int>

    var totalRewardCyclesEarned: Int {
        totalDailyStars / Self.starsPerReward
    }

    var totalRewardCyclesClaimed: Int {
        claimedCycleNumbers.filter { $0 >= 1 && $0 <= totalRewardCyclesEarned }.count
    }

    var readyCycleNumber: Int? {
        guard totalRewardCyclesClaimed < totalRewardCyclesEarned else { return nil }
        return (1...totalRewardCyclesEarned).first { !claimedCycleNumbers.contains($0) }
    }

    var isTreasureAvailable: Bool {
        readyCycleNumber != nil
    }

    var readyReward: RewardDefinition? {
        readyCycleNumber.map(RewardCatalog.reward)
    }

    var progressTowardNextReward: Int {
        guard !isTreasureAvailable else { return Self.starsPerReward }
        let starsAfterClaimedCycles = totalDailyStars - (totalRewardCyclesClaimed * Self.starsPerReward)
        return max(0, min(Self.starsPerReward, starsAfterClaimedCycles))
    }
}

@MainActor
enum RewardUnlocking {
    static func status(dailyStars: [DailyStar], rewardUnlocks: [RewardUnlock]) -> RewardJourneyStatus {
        RewardJourneyStatus(
            totalDailyStars: dailyStars.count,
            claimedCycleNumbers: Set(rewardUnlocks.map(\.cycleNumber))
        )
    }

    static func status(in context: ModelContext) throws -> RewardJourneyStatus {
        let stars = try context.fetch(FetchDescriptor<DailyStar>())
        let unlocks = try context.fetch(FetchDescriptor<RewardUnlock>())
        return status(dailyStars: stars, rewardUnlocks: unlocks)
    }

    @discardableResult
    static func claimNextAvailableReward(in context: ModelContext, unlockedAt: Date = .now) throws -> RewardUnlock? {
        let status = try status(in: context)
        guard let cycleNumber = status.readyCycleNumber else { return nil }

        let cycleKey = RewardUnlock.cycleKey(for: cycleNumber)
        var existingRequest = FetchDescriptor<RewardUnlock>(predicate: #Predicate { $0.cycleKey == cycleKey })
        existingRequest.fetchLimit = 1
        guard try context.fetch(existingRequest).isEmpty else { return nil }

        let reward = RewardCatalog.reward(forCycle: cycleNumber)
        let unlock = RewardUnlock(
            rewardIdentifier: reward.id,
            cycleNumber: cycleNumber,
            unlockedAt: unlockedAt
        )
        context.insert(unlock)
        return unlock
    }
}
