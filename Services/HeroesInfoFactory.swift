import UIKit

protocol HeroesInfoFactoryProtocol: AnyObject {
    func loadData()
    func loadAbilitiesIcon(iconName: String, abilitiesView: UIImageView)
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
    
    func loadAbilitiesIcon(iconName: String, abilitiesView: UIImageView) {
        DispatchQueue.global().async {
            guard let url = URL(string: "https://cdn.akamai.steamstatic.com/apps/dota2/images/dota_react/abilities/\(iconName).png") else {return}
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: url)
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.delegateViewController?.didFailToLoadImage(with: error)
                    return
                }
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.delegateViewController?.didLoadImageFromServer(imageData: imageData, abilitiesView: abilitiesView)
            }
        }
        
    }
    
    
}
