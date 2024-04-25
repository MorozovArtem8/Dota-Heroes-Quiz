import UIKit

class QuestionFactory: QuestionFactoryProtocol {
    private weak var delegateViewController: QuestionFactoryDelegate?
    private let heroesLoader: HeroesLoader
    
    init(delegateViewController: QuestionFactoryDelegate, heroesLoader: HeroesLoader) {
        self.delegateViewController = delegateViewController
        self.heroesLoader = heroesLoader
    }
    
    private var heroesStat = Heroes()
    
    func loadData() {
        heroesLoader.loadHeroes { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result {
                case .success(let heroes):
                    self.heroesStat = heroes
                    self.delegateViewController?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegateViewController?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0...self.heroesStat.count - 1).randomElement() ?? 0
            let hero = heroesStat[index]
            
            var imageData = Data()
            
            do {
                if let heroesImageUrl = hero.imageURL {
                    imageData = try Data(contentsOf: heroesImageUrl)
                }
                
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {return}
                    self.delegateViewController?.didFailToLoadImage(with: error)
                    return
                }
            }
            
            let heroesDataModel = HeroesDataModel(name: hero.name, attribute: hero.primaryAttr.rawValue, image: imageData)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                delegateViewController?.didReceiveNextQuestion(question: heroesDataModel)
            }
            
        }
    }
}
