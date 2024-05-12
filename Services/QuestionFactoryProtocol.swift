import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion()
    func loadData()
}

protocol QuestionFactoryProtocolGet {
    func getHeroes() -> Heroes
}
