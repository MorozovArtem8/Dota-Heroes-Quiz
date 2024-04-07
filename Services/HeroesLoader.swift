import UIKit

final class ApiManager {
    static let shared = ApiManager()
    let urlString = "https://api.opendota.com/api/heroStats"
    func getHeroes(completion: @escaping (Heroes)-> Void) {
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else {return}
            if let heroesData = try? JSONDecoder().decode(Heroes.self, from: data){
                print("все ок")
                completion(heroesData)
            }else{
                print("НЕ ОК")
            }
        }
        task.resume()
    }
}

struct HeroesLoader {
    
    private let networkClient = NetworkClient()
    
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
