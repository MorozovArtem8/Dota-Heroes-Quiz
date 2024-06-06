import XCTest
@testable import DotaHeroes

final class HeroesNetworkTest: XCTestCase {
    
    func testSuccessLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = HeroesLoader(networkClient: stubNetworkClient)
        
        //When
        let expectation = expectation(description: "Loading expectation")
        loader.loadHeroes { result in
            //Than
            
            switch result {
            case .success(let heroes):
                XCTAssertEqual(heroes.count, 2)
                expectation.fulfill()
            case .failure(_):
                XCTFail("Unexpected failure")
            }
        }
        waitForExpectations(timeout: 1)
        
    }
    
    func testFailureLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: true)
        let loader = HeroesLoader(networkClient: stubNetworkClient)
        // When
        let expectation = expectation(description: "Loading expectation")
        loader.loadHeroes { result in
            // Then
            switch result {
            case .success(_):
                XCTFail("Unexpected failure")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1)
    }
    
    
    
    func testCorrectParsing() throws {
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = HeroesLoader(networkClient: stubNetworkClient)
        
        let expectation = expectation(description: "Loading expectation")
        loader.loadHeroes { result in
            // Then
            switch result {
            case .success(let data):
                guard let firstHero = data.first, let secondHero = data.last else {
                    XCTFail("Unexpected failure")
                     return}
                
                let firstHeroName = firstHero.localizedName
                let firstHeroAtr = firstHero.primaryAttr
                
                let lastHeroName = secondHero.localizedName
                let lastHeroAtr = secondHero.primaryAttr
                
                XCTAssertEqual(firstHeroName, "Anti-Mage")
                XCTAssertEqual(firstHeroAtr.rawValue, "agi")
                
                XCTAssertEqual(lastHeroName, "Axe")
                XCTAssertEqual(lastHeroAtr.rawValue, "str")
                
                expectation.fulfill()
            case .failure(_):
                XCTFail("Unexpected failure")
            }
        }
        waitForExpectations(timeout: 1)
    }
    
    
    
    struct StubNetworkClient: NetworkRoutingFetch {
        
        enum TestError: Error {
            case test
        }
        
        let emulateError: Bool
        
        func fetch(url: URL, handler: @escaping (Result<Data, any Error>) -> Void) {
            if emulateError {
                handler(.failure(TestError.test))
            } else {
                handler(.success(expectedResponse))
            }
        }
        
        private var expectedResponse: Data {
        """
    [
      {
        "id": 1,
        "name": "npc_dota_hero_antimage",
        "primary_attr": "agi",
        "attack_type": "Melee",
        "roles": [
          "Carry",
          "Escape",
          "Nuker"
        ],
        "img": "/apps/dota2/images/dota_react/heroes/antimage.png?",
        "icon": "/apps/dota2/images/dota_react/heroes/icons/antimage.png?",
        "base_health": 120,
        "base_health_regen": 0.75,
        "base_mana": 75,
        "base_mana_regen": 0,
        "base_armor": 1,
        "base_mr": 25,
        "base_attack_min": 29,
        "base_attack_max": 33,
        "base_str": 19,
        "base_agi": 24,
        "base_int": 12,
        "str_gain": 1.6,
        "agi_gain": 2.8,
        "int_gain": 1.8,
        "attack_range": 150,
        "projectile_speed": 0,
        "attack_rate": 1.4,
        "base_attack_time": 100,
        "attack_point": 0.3,
        "move_speed": 310,
        "turn_rate": null,
        "cm_enabled": true,
        "legs": null,
        "day_vision": 1800,
        "night_vision": 800,
        "localized_name": "Anti-Mage",
        "1_pick": 16332,
        "1_win": 8305,
        "2_pick": 62946,
        "2_win": 32960,
        "3_pick": 102795,
        "3_win": 54431,
        "4_pick": 112708,
        "4_win": 59797,
        "5_pick": 84694,
        "5_win": 44793,
        "6_pick": 47972,
        "6_win": 25429,
        "7_pick": 25353,
        "7_win": 13295,
        "8_pick": 12144,
        "8_win": 6270,
        "turbo_picks": 251894,
        "turbo_picks_trend": [
          21453,
          21977,
          37505,
          45477,
          50283,
          40949,
          34250
        ],
        "turbo_wins": 132811,
        "turbo_wins_trend": [
          11406,
          11639,
          19748,
          24025,
          26409,
          21606,
          17978
        ],
        "pro_pick": 166,
        "pro_win": 75,
        "pro_ban": 479,
        "pub_pick": 502936,
        "pub_pick_trend": [
          76461,
          69800,
          66424,
          81253,
          84956,
          68767,
          55275
        ],
        "pub_win": 264330,
        "pub_win_trend": [
          39938,
          36455,
          35215,
          42862,
          44702,
          36101,
          29057
        ]
      },
      {
        "id": 2,
        "name": "npc_dota_hero_axe",
        "primary_attr": "str",
        "attack_type": "Melee",
        "roles": [
          "Initiator",
          "Durable",
          "Disabler",
          "Carry"
        ],
        "img": "/apps/dota2/images/dota_react/heroes/axe.png?",
        "icon": "/apps/dota2/images/dota_react/heroes/icons/axe.png?",
        "base_health": 120,
        "base_health_regen": 2.5,
        "base_mana": 75,
        "base_mana_regen": 0,
        "base_armor": 0,
        "base_mr": 25,
        "base_attack_min": 30,
        "base_attack_max": 34,
        "base_str": 25,
        "base_agi": 20,
        "base_int": 18,
        "str_gain": 2.8,
        "agi_gain": 1.7,
        "int_gain": 1.6,
        "attack_range": 150,
        "projectile_speed": 900,
        "attack_rate": 1.7,
        "base_attack_time": 100,
        "attack_point": 0.4,
        "move_speed": 315,
        "turn_rate": null,
        "cm_enabled": true,
        "legs": null,
        "day_vision": 1800,
        "night_vision": 800,
        "localized_name": "Axe",
        "1_pick": 23065,
        "1_win": 12841,
        "2_pick": 84459,
        "2_win": 46650,
        "3_pick": 132819,
        "3_win": 72654,
        "4_pick": 142373,
        "4_win": 76255,
        "5_pick": 105569,
        "5_win": 56316,
        "6_pick": 57905,
        "6_win": 30741,
        "7_pick": 29171,
        "7_win": 15274,
        "8_pick": 10937,
        "8_win": 5640,
        "turbo_picks": 458056,
        "turbo_picks_trend": [
          30195,
          31491,
          70733,
          87659,
          95948,
          77852,
          64178
        ],
        "turbo_wins": 252735,
        "turbo_wins_trend": [
          16535,
          17236,
          39005,
          48707,
          53029,
          42718,
          35505
        ],
        "pro_pick": 335,
        "pro_win": 167,
        "pro_ban": 258,
        "pub_pick": 635908,
        "pub_pick_trend": [
          91585,
          84588,
          85684,
          106434,
          111364,
          87276,
          68977
        ],
        "pub_win": 343620,
        "pub_win_trend": [
          49129,
          45373,
          46453,
          57883,
          60395,
          47017,
          37370
        ]
      }]
""".data(using: .utf8) ?? Data()
        }
    }
}
    
