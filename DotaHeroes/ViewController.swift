import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var buttonsCollection: [UIButton]!
    
    var currentQuestion = 0
    var correctAnswer = 0
    
    var allHeroesDataModel: [HeroesDataModel] = []
    var heroesListNoIcon = Heroes()
    var heroesForQuiz: [HeroesDataModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ApiManager.shared.getHeroes(completion: { [weak self] heroes in
            DispatchQueue.main.async {
                guard let self else {return}
                self.heroesListNoIcon = heroes
                self.heroesListNoIcon.shuffle()
                
                self.heroesListNoIcon.forEach{hero in
                    let url = URL(string: "https://cdn.cloudflare.steamstatic.com\(hero.img)")
                    let data = try? Data(contentsOf: url!)
                    let image = UIImage(data: data!)
                    self.allHeroesDataModel.append(HeroesDataModel(name: hero.name, attribute: hero.primaryAttr.rawValue, image: image!))
                    
                }
                for i in 0...19 {
                    self.heroesForQuiz.append(self.allHeroesDataModel[i])
                }
                self.imageView.image = self.heroesForQuiz[0].image
                self.questionLabel.text = "\(self.currentQuestion + 1)/\(self.heroesForQuiz.count)"
                print(self.heroesForQuiz[0].attribute)
                
            }
            
            
        })
        
    }
    
    @IBAction func universalButtonTapped(_ sender: UIButton) {
        showResult(isCorrect: "all" == heroesForQuiz[currentQuestion].attribute)
    }
    @IBAction func strengthButtonTapped(_ sender: UIButton) {
        showResult(isCorrect: "str" == heroesForQuiz[currentQuestion].attribute)
    }
    @IBAction func agilityButtonTapped(_ sender: UIButton) {
        showResult(isCorrect: "agi" == heroesForQuiz[currentQuestion].attribute)
    }
    @IBAction func intellectButtonTapped(_ sender: UIButton) {
        showResult(isCorrect: "int" == heroesForQuiz[currentQuestion].attribute)
    }
    
    
    func showQuestionOrResult() {
        if currentQuestion == heroesForQuiz.count - 1 {
            let alert = UIAlertController(title: "Этот раунд окончен", message: "Ваш результат \(correctAnswer)/\(heroesForQuiz.count)", preferredStyle: .alert)
            let action = UIAlertAction(title: "ОК", style: .default, handler: {_ in
                self.currentQuestion = 0
                self.correctAnswer = 0
                self.heroesForQuiz = []
                self.heroesListNoIcon.shuffle()
                for i in 0...19 {
                    self.heroesForQuiz.append(self.allHeroesDataModel[i])
                }
                self.imageView.image = self.heroesForQuiz[0].image
                self.questionLabel.text = "\(self.currentQuestion + 1)/\(self.heroesForQuiz.count)"
            })
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
        }else {
            currentQuestion += 1
            self.questionLabel.text = "\(self.currentQuestion + 1)/\(self.heroesForQuiz.count)"
            imageView.image = heroesForQuiz[currentQuestion].image
        }
    }
    
    func showResult(isCorrect: Bool) {
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
            self.showQuestionOrResult()
        }
    }
    
}

