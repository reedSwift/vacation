import Foundation
import SwiftData

@Model
final class RewardUnlock {
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var cycleKey: String
    var rewardIdentifier: String
    var cycleNumber: Int
    var unlockedAt: Date

    init(rewardIdentifier: String, cycleNumber: Int, unlockedAt: Date = .now) {
        id = UUID()
        self.rewardIdentifier = rewardIdentifier
        self.cycleNumber = cycleNumber
        self.unlockedAt = unlockedAt
        cycleKey = RewardUnlock.cycleKey(for: cycleNumber)
    }

    static func cycleKey(for cycleNumber: Int) -> String {
        "reward-cycle-\(cycleNumber)"
    }
}
