import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThen(_ anotherGameRecord: GameRecord) -> Bool {
        correct > anotherGameRecord.correct
    }
}
