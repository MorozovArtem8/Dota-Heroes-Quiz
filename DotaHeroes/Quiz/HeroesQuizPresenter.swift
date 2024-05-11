import UIKit

final class HeroesQuizPresenter: QuestionFactoryDelegate {
    
    private var currentQuestionIndex = 0
    private let questionAmount = 10
    private var correctAnswers = 0
    
    private var currentQuestion: HeroesDataModel?
    
    var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticService
    
    private weak var viewController: HeroesQuizViewController?
    
    init(viewController: HeroesQuizViewController) {
        self.statisticService = StatisticServiceImplementation()
        self.viewController = viewController
        self.questionFactory = QuestionFactory(delegateViewController: self, heroesLoader: HeroesLoader())
        questionFactory?.loadData()
        
    }
    
    //MARK: QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: HeroesDataModel) {
        currentQuestion = question
        let quizStepViewModel = convert(heroesDataModel: question)
        viewController?.show(quizStepViewModel: quizStepViewModel)
    }
    
    func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: any Error) {
        viewController?.showNetworkError()
    }
    func didFailToLoadImage(with error: any Error) {
        viewController?.showLoadImageError()
    }
    
    
    //MARK: FUNC
    
    func universalButtonTapped() {
        let buttonAnswer = "all"
        didAnswer(answer: buttonAnswer)
    }
    func strengthButtonTapped() {
        let buttonAnswer =  "str"
        didAnswer(answer: buttonAnswer)
    }
    func agilityButtonTapped() {
        let buttonAnswer = "agi"
        didAnswer(answer: buttonAnswer)
    }
    func intellectButtonTapped() {
        let buttonAnswer =  "int"
        didAnswer(answer: buttonAnswer)
    }
    
    func didAnswer(answer: String) {
        guard let currentQuestion = currentQuestion else {return}
        currentQuestionIndex += 1
        let correctAnswer = answer == currentQuestion.attribute
        if correctAnswer {
            correctAnswers += 1
        }
        self.proceedWithAnswer(isCorrect: correctAnswer)
    }
    
    private func convert(heroesDataModel: HeroesDataModel) -> QuizStepViewModel {
        let name = heroesDataModel.name
        let attribute = heroesDataModel.attribute
        let image = UIImage(data: heroesDataModel.image) ?? UIImage()
        
        let questionNumber = "\(currentQuestionIndex + 1)/\(questionAmount)"
        
        return QuizStepViewModel(name: name, attribute: attribute, image: image, questionNumber: questionNumber)
    }
    
    private func proceedWithAnswer(isCorrect: Bool) {
        viewController?.highlightImageBorder(isCorrect: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.proceedToNextQuestionOrResults()
        }
    }
    
    private func proceedToNextQuestionOrResults() {
        if currentQuestionIndex  == questionAmount {
            let alertTitle = "Этот раунд окончен!"
            let alertMessage = makeResultMessage()
            let alertButtonText = "Сыграть еще раз"
            viewController?.showResultAlert(quizResultsViewModel: QuizResultsViewModel(title: alertTitle, text: alertMessage, buttonText: alertButtonText))
        }else{
            questionFactory?.requestNextQuestion()
        }
        
    }
    
    private func makeResultMessage() -> String {
        statisticService.store(correct: correctAnswers, total: questionAmount)
        
        let bestGame = statisticService.bestGame
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd-MM-yyyy HH:mm"
        
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)/\(questionAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)/\(bestGame.total)" + " (\(dateFormater.string(from: bestGame.date)))"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        let resultMessage = [currentGameResultLine, totalPlaysCountLine, averageAccuracyLine, bestGameInfoLine].joined(separator: "\n")
        
        return resultMessage
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func reloadingDataFromServer() {
        questionFactory?.loadData()
    }
    
    func reloadingImage() {
        questionFactory?.requestNextQuestion()
    }
    
    
}
