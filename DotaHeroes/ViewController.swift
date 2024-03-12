import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    
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
            //showresult
        }else {
            currentQuestion += 1
            self.questionLabel.text = "\(self.currentQuestion + 1)/\(self.heroesForQuiz.count)"
            imageView.image = heroesForQuiz[currentQuestion].image
        }
    }
    
    func showResult(isCorrect: Bool) {
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.borderWidth = 8
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.imageView.layer.borderWidth = 0
            self.showQuestionOrResult()
        }
    }
    
}

