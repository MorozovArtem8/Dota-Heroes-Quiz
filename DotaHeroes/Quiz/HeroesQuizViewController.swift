import UIKit

final class HeroesQuizViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private var buttonsCollection: [UIButton]!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: HeroesQuizPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = HeroesQuizPresenter(viewController: self)
        showLoader()
        
    }
    
    //MARK: IBAction
    @IBAction private func universalButtonTapped(_ sender: UIButton) {
        presenter?.universalButtonTapped()
    }
    @IBAction private func strengthButtonTapped(_ sender: UIButton) {
        presenter?.strengthButtonTapped()
    }
    @IBAction private func agilityButtonTapped(_ sender: UIButton) {
        presenter?.agilityButtonTapped()
    }
    @IBAction private func intellectButtonTapped(_ sender: UIButton) {
        presenter?.intellectButtonTapped()
    }
    
    //MARK: func
    
    func show(quizStepViewModel: QuizStepViewModel) {
        hideLoader()
        buttonsCollection.forEach{
            $0.isEnabled = true
        }
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = quizStepViewModel.image
        questionLabel.text = quizStepViewModel.questionNumber
    }
    
    func showResultAlert(quizResultsViewModel: QuizResultsViewModel) {
        let alertModel = AlertModel(
            title: quizResultsViewModel.title,
            message: quizResultsViewModel.text,
            buttonText: quizResultsViewModel.buttonText) { [weak self] in
                self?.presenter?.restartGame()
            }
        let alertPresenter = AlertPresenter(viewController: self)
        alertPresenter.show(alertModel: alertModel)
    }
    
    
    func highlightImageBorder(isCorrect: Bool) {
        showLoader()
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.borderWidth = 8
        buttonsCollection.forEach{
            $0.isEnabled = false
        }
    }
    
    func showNetworkError() {
        let alertModel = AlertModel(
            title: "Ошибка",
            message: "Не удалось загрузить данные",
            buttonText: "Попробовать снова",
            completion: { [weak self] in
                self?.presenter?.reloadingDataFromServer()
            })
        let alertPresenter = AlertPresenter(viewController: self)
        alertPresenter.show(alertModel: alertModel)
    }
    
    func showLoadImageError() {
        let alertModel = AlertModel(
            title: "Ошибка",
            message: "Что то пошло не так",
            buttonText: "Попробовать снова",
            completion: { [weak self] in
                self?.showLoader()
                self?.presenter?.reloadingImage()
            })
        let alertPresenter = AlertPresenter(viewController: self)
        alertPresenter.show(alertModel: alertModel)
    }
    
    
    private func showLoader() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoader() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func passQuestionFactory() -> QuestionFactoryProtocol?{
        presenter?.questionFactory
    }
    
}


