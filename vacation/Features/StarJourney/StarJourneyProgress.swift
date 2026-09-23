struct StarJourneyProgress {
    let total: Int
    var claimedRewardCycles = 0

    var earned: Int {
        RewardJourneyStatus(
            totalDailyStars: total,
            claimedCycleNumbers: claimedRewardCycles > 0 ? Set(1...claimedRewardCycles) : []
        )
        .progressTowardNextReward
    }

    var message: String {
        switch earned {
        case 0: claimedRewardCycles > 0 ? "Let’s start our next star adventure!" : "Let’s earn your first star!"
        case 1: "1 star earned!"
        case 2...5: "\(earned) stars earned! \(7 - earned) more until your surprise!"
        case 6: "Just 1 more star until your surprise!"
        default: "Your surprise is ready! 🎁"
        }
    }
}
