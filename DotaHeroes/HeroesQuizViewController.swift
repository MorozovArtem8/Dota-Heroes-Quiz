import UIKit

final class HeroesQuizViewController: UIViewController, QuestionFactoryDelegate {
  
    
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private var buttonsCollection: [UIButton]!
    
    private var  loader: UIAlertController = UIAlertController()
   
    private var currentQuestion = 0
    private let questionAmount = 10
    private var correctAnswer = 0
    
    private var questionFactory: QuestionFactoryProtocol?
  
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory(delegateViewController: self, heroesLoader: HeroesLoader())
        questionFactory?.loadData()
      
        
    }
    //MARK: QuestionFactoryDelegate
    func didReceiveNextQuestion(question: HeroesDataModel) {
        let quizStepViewModel = convert(heroesDataModel: question)
        show(quizStepViewModel: quizStepViewModel)
    }
    
    func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: any Error) {
        
    }
    
    func didFailToLoadImage(with error: any Error) {
        
    }
    //MARK: IBAction
    @IBAction func universalButtonTapped(_ sender: UIButton) {
        //showResult(isCorrect: "all" == heroesForQuiz[currentQuestion].attribute)
    }
    @IBAction func strengthButtonTapped(_ sender: UIButton) {
        //showResult(isCorrect: "str" == heroesForQuiz[currentQuestion].attribute)
    }
    @IBAction func agilityButtonTapped(_ sender: UIButton) {
        //showResult(isCorrect: "agi" == heroesForQuiz[currentQuestion].attribute)
    }
    @IBAction func intellectButtonTapped(_ sender: UIButton) {
        //showResult(isCorrect: "int" == heroesForQuiz[currentQuestion].attribute)
    }
    
    //MARK: func
    
    private func show(quizStepViewModel: QuizStepViewModel) {
        imageView.image = quizStepViewModel.image
        questionLabel.text = "\(currentQuestion + 1)/\(questionAmount)"
    }
    
//    private func showQuestionOrResult() {
//        if currentQuestion == heroesForQuiz.count - 1 {
//            let alert = UIAlertController(title: "Этот раунд окончен", message: "Ваш результат \(correctAnswer)/\(heroesForQuiz.count)", preferredStyle: .alert)
//            let action = UIAlertAction(title: "ОК", style: .default, handler: {_ in
//                self.currentQuestion = 0
//                self.correctAnswer = 0
//                self.heroesForQuiz = []
//                self.allHeroesDataModel.shuffle()
//                for i in 0...19 {
//                    self.heroesForQuiz.append(self.allHeroesDataModel[i])
//                }
//                self.imageView.image = self.heroesForQuiz[0].image
//                self.questionLabel.text = "\(self.currentQuestion + 1)/\(self.heroesForQuiz.count)"
//            })
//            alert.addAction(action)
//            present(alert, animated: true, completion: nil)
//            
//        }else {
//            currentQuestion += 1
//            self.questionLabel.text = "\(self.currentQuestion + 1)/\(self.heroesForQuiz.count)"
//            imageView.image = heroesForQuiz[currentQuestion].image
//        }
//    }
    
    private func showResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswer += 1
        }
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.borderWidth = 8
        
        buttonsCollection.forEach{
            $0.isEnabled = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.buttonsCollection.forEach{
                $0.isEnabled = true
            }
            self.imageView.layer.borderWidth = 0
            //self.showQuestionOrResult()
        }
    }
    
    private func convert(heroesDataModel: HeroesDataModel) -> QuizStepViewModel {
        let name = heroesDataModel.name
        let attribute = heroesDataModel.attribute
        let image = UIImage(data: heroesDataModel.image) ?? UIImage()
        
        return QuizStepViewModel(name: name, attribute: attribute, image: image)
    }
    
}


