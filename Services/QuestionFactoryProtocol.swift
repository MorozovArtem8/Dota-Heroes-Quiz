import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion()
    func loadData()
    func getHeroes() -> Heroes
}

