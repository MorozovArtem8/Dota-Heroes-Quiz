import Foundation

struct CurrentHeroInfo: Decodable {
    let result: Result
    
    struct Result: Decodable {
        let data: Data
        
        struct Data: Decodable {
            let heroes: [Hero]
            
        }
    }
}

struct Hero: Decodable {
    let id: Int
    let nameLoc: String
    let bioLoc: String
    let abilities: [Abilities]
    
    enum CodingKeys: String, CodingKey {
            case id
            case nameLoc = "name_loc"
            case bioLoc = "bio_loc"
            case abilities
        }
}

struct Abilities: Decodable{
    let name: String
    let nameLoc: String
    let descLoc: String
    
    enum CodingKeys: String, CodingKey {
            case name
            case nameLoc = "name_loc"
            case descLoc = "desc_loc"
        }
}
