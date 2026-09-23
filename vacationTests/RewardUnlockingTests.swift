import XCTest
import SwiftData
@testable import vacation

@MainActor
final class RewardUnlockingTests: XCTestCase {
    func testRewardAvailabilityExamples() throws {
        XCTAssertStatus(stars: 6, claimedCycles: [], availableCycle: nil, progress: 6)
        XCTAssertStatus(stars: 7, claimedCycles: [], availableCycle: 1, progress: 7)
        XCTAssertStatus(stars: 7, claimedCycles: [1], availableCycle: nil, progress: 0)
        XCTAssertStatus(stars: 8, claimedCycles: [1], availableCycle: nil, progress: 1)
        XCTAssertStatus(stars: 14, claimedCycles: [1], availableCycle: 2, progress: 7)
        XCTAssertStatus(stars: 14, claimedCycles: [1, 2], availableCycle: nil, progress: 0)
    }

    func testCatalogCyclesAfterSixRewards() {
        XCTAssertEqual(RewardCatalog.reward(forCycle: 1).displayName, "Unicorn Superstar")
        XCTAssertEqual(RewardCatalog.reward(forCycle: 6).displayName, "Space Explorer")
        XCTAssertEqual(RewardCatalog.reward(forCycle: 7).displayName, "Unicorn Superstar")
    }

    func testClaimingOnlyCreatesOneUnlockPerEarnedCycle() throws {
        let container = try ModelContainer(for: DailyStar.self, RewardUnlock.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let context = container.mainContext

        insertStars(7, into: context)

        let first = try XCTUnwrap(RewardUnlocking.claimNextAvailableReward(in: context))
        try context.save()
        XCTAssertEqual(first.cycleNumber, 1)
        XCTAssertEqual(first.rewardIdentifier, "unicorn-superstar")

        XCTAssertNil(try RewardUnlocking.claimNextAvailableReward(in: context))
        try context.save()
        XCTAssertEqual(try context.fetchCount(FetchDescriptor<RewardUnlock>()), 1)

        insertStars(7, into: context, startingDaysAgo: 8)
        let second = try XCTUnwrap(RewardUnlocking.claimNextAvailableReward(in: context))
        try context.save()
        XCTAssertEqual(second.cycleNumber, 2)
        XCTAssertEqual(second.rewardIdentifier, "super-scientist")
        XCTAssertEqual(try context.fetchCount(FetchDescriptor<DailyStar>()), 14)
        XCTAssertEqual(try context.fetchCount(FetchDescriptor<RewardUnlock>()), 2)
    }

    private func XCTAssertStatus(
        stars: Int,
        claimedCycles: Set<Int>,
        availableCycle: Int?,
        progress: Int,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let status = RewardJourneyStatus(totalDailyStars: stars, claimedCycleNumbers: claimedCycles)
        XCTAssertEqual(status.readyCycleNumber, availableCycle, file: file, line: line)
        XCTAssertEqual(status.isTreasureAvailable, availableCycle != nil, file: file, line: line)
        XCTAssertEqual(status.progressTowardNextReward, progress, file: file, line: line)
    }

    private func insertStars(_ count: Int, into context: ModelContext, startingDaysAgo: Int = 0) {
        let calendar = Calendar.current
        for offset in startingDaysAgo..<(startingDaysAgo + count) {
            let date = calendar.date(byAdding: .day, value: -offset, to: .now)!
            context.insert(DailyStar(date: date))
        }
    }
}
