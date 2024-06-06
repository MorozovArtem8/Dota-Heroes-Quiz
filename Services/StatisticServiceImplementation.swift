import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int)
}

final class StatisticServiceImplementation: StatisticService {
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private let userDefaults = UserDefaults.standard
    
    var totalAccuracy: Double {
        get {
            let correct = userDefaults.integer(forKey: Keys.correct.rawValue)
            let total = userDefaults.integer(forKey: Keys.total.rawValue)
            let totalAccuracy = Double(correct) / Double(total) * 100
            return totalAccuracy
        }
        
    }
    
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue), let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return GameRecord(correct: 0, total: 0, date: Date())
            }
            return record
            
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {return}
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        
        let totalCount = userDefaults.integer(forKey: Keys.correct.rawValue)
        let totalAmount = userDefaults.integer(forKey: Keys.total.rawValue)
        
        userDefaults.set(count + totalCount, forKey: Keys.correct.rawValue)
        userDefaults.set(amount + totalAmount, forKey: Keys.total.rawValue)
        
        let newGameStat = GameRecord(correct: count, total: amount, date: Date())
        
        if newGameStat.isBetterThen(bestGame) {
            bestGame = newGameStat
        }
    }
    
    
}
