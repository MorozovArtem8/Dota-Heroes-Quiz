import Foundation

protocol HeroesInfoFactoryProtocol: AnyObject {
    func loadData()
    
}

class HeroesInfoFactory: HeroesInfoFactoryProtocol {
    
    private let heroesInfoLoader = HeroInfoLoader()
    private let heroId: String
    private weak var delegateViewController: HeroesInfoFactoryDelegate?
    
    init(heroId: String, delegateViewController: HeroesInfoFactoryDelegate) {
        self.heroId = heroId
        self.delegateViewController = delegateViewController
    }
    
    func loadData() {
        heroesInfoLoader.loadHeroInfo(heroId: heroId) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result {
                case .success(let heroInfo):
                    self.delegateViewController?.didLoadDataFromServer(heroInfo: heroInfo)
                    print("Данные скачали")
                    
                case .failure(let error):
                    self.delegateViewController?.didFailToLoadData(with: error)
                    print("Ошибка загрузки")
                }
                
            }
        }
    }
    
    
}
