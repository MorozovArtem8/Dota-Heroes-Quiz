import XCTest
@testable import DotaHeroes

final class SaveGameRecordTest: XCTestCase {
    
    func testGameRecordSave() throws {
        let firstRecord = GameRecord(correct: 7, total: 10, date: Date())
        let secondRecord = GameRecord(correct: 6, total: 10, date: Date())
        XCTAssertTrue(firstRecord.isBetterThen(secondRecord))
    }
    
}
