import UIKit

final class HeroesQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private var buttonsCollection: [UIButton]!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    private var currentQuestionIndex = 0
    private let questionAmount = 10
    private var correctAnswer = 0
    
    private var currentQuestion: HeroesDataModel?
    
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticService?
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statisticService = StatisticServiceImplementation()
        showLoader()
        questionFactory = QuestionFactory(delegateViewController: self, heroesLoader: HeroesLoader())
        questionFactory?.loadData()
        
        
    }
    //MARK: QuestionFactoryDelegate
    func didReceiveNextQuestion(question: HeroesDataModel) {
        currentQuestion = question
        let quizStepViewModel = convert(heroesDataModel: question)
        show(quizStepViewModel: quizStepViewModel)
        hideLoader()
    }
    
    func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: any Error) {
        let alertModel = AlertModel(
            title: "Ошибка",
            message: "Что то пошло не так",
            buttonText: "Попробовать снова",
            completion: { [weak self] in
                self?.questionFactory?.loadData()
            })
        let alertPresentor = AlertPresentror(viewController: self)
        alertPresentor.show(alertModel: alertModel)
    }
    
    //MARK: IBAction
    @IBAction func universalButtonTapped(_ sender: UIButton) {
        showResult(isCorrect: "all" == currentQuestion?.attribute)
    }
    @IBAction func strengthButtonTapped(_ sender: UIButton) {
        showResult(isCorrect: "str" == currentQuestion?.attribute)
    }
    @IBAction func agilityButtonTapped(_ sender: UIButton) {
        showResult(isCorrect: "agi" == currentQuestion?.attribute)
    }
    @IBAction func intellectButtonTapped(_ sender: UIButton) {
        showResult(isCorrect: "int" == currentQuestion?.attribute)
    }
    
    //MARK: func
    
    private func show(quizStepViewModel: QuizStepViewModel) {
        imageView.image = quizStepViewModel.image
        questionLabel.text = "\(currentQuestionIndex + 1)/\(questionAmount)"
    }
    
    private func showQuestionOrResult() {
        if currentQuestionIndex >= questionAmount - 1 {
            statisticService?.store(correct: correctAnswer, total: questionAmount)
            
            guard let totalQuiz = statisticService?.gamesCount,
                  let gameRecord = statisticService?.bestGame,
                  let totalAccuracy = statisticService?.totalAccuracy
            else {return}
            
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "dd-MM-yyyy HH:mm"
            let dateString = dateFormater.string(from: gameRecord.date)
            
            let alertMessage = """
Ваш результат: \(correctAnswer) / \(questionAmount)
Количество сыгранных квизов: \(totalQuiz)
Рекорд: \(gameRecord.correct)/\(gameRecord.total) ( \(dateString) )
Средняя точность: \(String(format: "%.2f", totalAccuracy))%"
"""
            
            let alertTitle = "Этот раунд окончен"
            let alertModel = AlertModel(
                title: alertTitle,
                message: alertMessage,
                buttonText: "Сыграть еще раз") { [weak self] in
                    self?.correctAnswer = 0
                    self?.currentQuestionIndex = 0
                    self?.questionFactory?.requestNextQuestion()
                }
            let alertPresentor = AlertPresentror(viewController: self)
            alertPresentor.show(alertModel: alertModel)
            
        }else {
            currentQuestionIndex += 1
            self.questionLabel.text = "\(self.currentQuestionIndex + 1)/\(self.questionAmount)"
            self.questionFactory?.requestNextQuestion()
        }
    }
    
    private func showResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswer += 1
        }
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.borderWidth = 8
        
        buttonsCollection.forEach{
            $0.isEnabled = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else {return}
            self.buttonsCollection.forEach{
                $0.isEnabled = true
            }
            self.imageView.layer.borderWidth = 0
            self.showQuestionOrResult()
        }
    }
    
    private func convert(heroesDataModel: HeroesDataModel) -> QuizStepViewModel {
        let name = heroesDataModel.name
        let attribute = heroesDataModel.attribute
        let image = UIImage(data: heroesDataModel.image) ?? UIImage()
        
        return QuizStepViewModel(name: name, attribute: attribute, image: image)
    }
    
    private func showLoader() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoader() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
}


