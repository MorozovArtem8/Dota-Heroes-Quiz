import Foundation

struct HeroInfoLoader {
    private let networkClient: NetworkRoutingFetchForRequest
    
    init(networkClient: NetworkRoutingFetchForRequest = NetworkClient()) {
        self.networkClient = networkClient
    }
    
   private func loadCurrentHeroInfo(heroId: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://www.dota2.com/datafeed/herodata") else {return nil}
        urlComponents.queryItems = [
            URLQueryItem(name: "language", value: "russian"),
            URLQueryItem(name: "hero_id", value: heroId)
        ]
        
        guard let url = urlComponents.url else {return nil}
        let request = URLRequest(url: url)
        return request
    }
    
    func loadHeroInfo(heroId: String, handler: @escaping (Result<CurrentHeroInfo, Error>) -> Void) {
        guard let request = loadCurrentHeroInfo(heroId: heroId) else {return}
        networkClient.fetchForRequest(request: request) { result in
            switch result {
            case .success(let data):
                do{
                    let heroesInfo = try JSONDecoder().decode(CurrentHeroInfo.self, from: data)
                    handler(.success(heroesInfo))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
}

