import UIKit

class ApiManager {
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
