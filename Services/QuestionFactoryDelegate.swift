import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: HeroesDataModel)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
