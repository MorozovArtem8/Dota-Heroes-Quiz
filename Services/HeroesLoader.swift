import UIKit

struct HeroesLoader {
    
    private let networkClient: NetworkRoutingFetch
    
    init(networkClient: NetworkRoutingFetch = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    private var heroesUrl: URL {
        guard let url = URL(string: "https://api.opendota.com/api/heroStats") else {
            preconditionFailure("Unable to construct heroesUrl")
        }
        return url
    }
    
    func loadHeroes(handler: @escaping (Result<Heroes, Error>) -> Void) {
        networkClient.fetch(url: heroesUrl) { result in
            switch result{
            case .success(let data):
                do {
                    let heroes = try JSONDecoder().decode(Heroes.self, from: data)
                    handler(.success(heroes))
                }
                catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
