import XCTest
@testable import vacation

final class StarJourneyProgressTests: XCTestCase {
    func testSevenStarGroups() {
        for (total, expected) in [(0,0), (1,1), (2,2), (5,5), (6,6), (7,7), (8,7), (13,7), (14,7), (15,7)] {
            XCTAssertEqual(StarJourneyProgress(total: total).earned, expected)
        }
        XCTAssertEqual(StarJourneyProgress(total: 0).message, "Let’s earn your first star!")
        XCTAssertEqual(StarJourneyProgress(total: 1).message, "1 star earned!")
        XCTAssertEqual(StarJourneyProgress(total: 3).message, "3 stars earned! 4 more until your surprise!")
        XCTAssertEqual(StarJourneyProgress(total: 6).message, "Just 1 more star until your surprise!")
        XCTAssertEqual(StarJourneyProgress(total: 7).message, "Your surprise is ready! 🎁")
    }

    func testProgressAfterClaimedRewardCycles() {
        XCTAssertEqual(StarJourneyProgress(total: 7, claimedRewardCycles: 1).earned, 0)
        XCTAssertEqual(StarJourneyProgress(total: 8, claimedRewardCycles: 1).earned, 1)
        XCTAssertEqual(StarJourneyProgress(total: 14, claimedRewardCycles: 1).earned, 7)
        XCTAssertEqual(StarJourneyProgress(total: 14, claimedRewardCycles: 2).earned, 0)
    }
}
