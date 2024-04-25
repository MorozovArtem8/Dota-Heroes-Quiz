import XCTest
@testable import DotaHeroes

final class SaveGamesCountTest: XCTestCase {

    func testSaveGame() throws {
        let statisticService = StatisticServiceImplementation()
        let totalGame = statisticService.gamesCount
        statisticService.store(correct: 9, total: 10)
        let newTotal = statisticService.gamesCount
        XCTAssertEqual(totalGame, newTotal - 1)
    }

}
