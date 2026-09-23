import Foundation

struct RewardDefinition: Equatable, Identifiable {
    let id: String
    let displayName: String
    let visualIdentifier: String
}

enum RewardCatalog {
    static let rewards: [RewardDefinition] = [
        RewardDefinition(id: "unicorn-superstar", displayName: "Unicorn Superstar", visualIdentifier: "🦄"),
        RewardDefinition(id: "super-scientist", displayName: "Super Scientist", visualIdentifier: "🔬"),
        RewardDefinition(id: "rainbow-star", displayName: "Rainbow Star", visualIdentifier: "🌈"),
        RewardDefinition(id: "dolphin-friend", displayName: "Dolphin Friend", visualIdentifier: "🐬"),
        RewardDefinition(id: "little-queen", displayName: "Little Queen", visualIdentifier: "👑"),
        RewardDefinition(id: "space-explorer", displayName: "Space Explorer", visualIdentifier: "🚀")
    ]

    static func reward(forCycle cycleNumber: Int) -> RewardDefinition {
        let index = (max(cycleNumber, 1) - 1) % rewards.count
        return rewards[index]
    }
}
