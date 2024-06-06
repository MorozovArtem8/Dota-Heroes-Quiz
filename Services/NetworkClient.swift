import Foundation

protocol NetworkRoutingFetch {
    func fetch(url: URL, handler: @escaping (Result <Data, Error>) -> Void)
}

protocol NetworkRoutingFetchForRequest {
    func fetchForRequest(request: URLRequest, handler: @escaping (Result <Data, Error>) -> Void)
}

struct NetworkClient: NetworkRoutingFetch, NetworkRoutingFetchForRequest {
    
    enum NetworkError: Error {
        case codeError
        
    }
    
    func fetch(url: URL, handler: @escaping (Result <Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                handler(.failure(error))
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            guard let data = data else {return}
            handler(.success(data))
        }
        task.resume()
    }
    
    func fetchForRequest(request: URLRequest, handler: @escaping (Result <Data, Error>) -> Void) {
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                handler(.failure(error))
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            guard let data = data else {return}
            handler(.success(data))
        }
        task.resume()
    }
}
