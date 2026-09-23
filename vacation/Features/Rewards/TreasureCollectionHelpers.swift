import Foundation

enum TreasureCollection {
    static func unlockedRewardIDs(from unlocks: [RewardUnlock]) -> Set<String> {
        Set(unlocks.map(\.rewardIdentifier))
    }

    static func isUnlocked(_ reward: RewardDefinition, unlocks: [RewardUnlock]) -> Bool {
        unlockedRewardIDs(from: unlocks).contains(reward.id)
    }
}
