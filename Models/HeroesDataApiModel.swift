import UIKit

struct HeroesData: Codable {
    let id: Int
    let name: String
    let primaryAttr: PrimaryAttr
    let attackType: AttackType
    let roles: [Role]
    let img, icon: String
    let baseHealth: Int
    let baseHealthRegen: Double
    let baseMana: Int
    let baseManaRegen, baseArmor: Double
    let baseMr, baseAttackMin, baseAttackMax, baseStr: Int
    let baseAgi, baseInt: Int
    let strGain, agiGain, intGain: Double
    let attackRange, projectileSpeed: Int
    let attackRate: Double
    let baseAttackTime: Int
    let attackPoint: Double
    let moveSpeed: Int
    let turnRate: Double?
    let cmEnabled: Bool
    let legs: Int?
    let dayVision, nightVision: Int
    let localizedName: String
    let the1_Pick, the1_Win, the2_Pick, the2_Win: Int
    let the3_Pick, the3_Win, the4_Pick, the4_Win: Int
    let the5_Pick, the5_Win, the6_Pick, the6_Win: Int
    let the7_Pick, the7_Win, the8_Pick, the8_Win: Int
    let turboPicks: Int
    let turboPicksTrend: [Int]
    let turboWINS: Int
    let turboWINSTrend: [Int]
    let proPick, proWin, proBan, pubPick: Int
    let pubPickTrend: [Int]
    let pubWin: Int
    let pubWinTrend: [Int]
    
    var imageURL: URL? {
        let urlString = "https://cdn.cloudflare.steamstatic.com\(img)"
        guard let url = URL(string: urlString) else {return nil}
        return url
    }

    enum CodingKeys: String, CodingKey {
        case id, name
        case primaryAttr = "primary_attr"
        case attackType = "attack_type"
        case roles, img, icon
        case baseHealth = "base_health"
        case baseHealthRegen = "base_health_regen"
        case baseMana = "base_mana"
        case baseManaRegen = "base_mana_regen"
        case baseArmor = "base_armor"
        case baseMr = "base_mr"
        case baseAttackMin = "base_attack_min"
        case baseAttackMax = "base_attack_max"
        case baseStr = "base_str"
        case baseAgi = "base_agi"
        case baseInt = "base_int"
        case strGain = "str_gain"
        case agiGain = "agi_gain"
        case intGain = "int_gain"
        case attackRange = "attack_range"
        case projectileSpeed = "projectile_speed"
        case attackRate = "attack_rate"
        case baseAttackTime = "base_attack_time"
        case attackPoint = "attack_point"
        case moveSpeed = "move_speed"
        case turnRate = "turn_rate"
        case cmEnabled = "cm_enabled"
        case legs
        case dayVision = "day_vision"
        case nightVision = "night_vision"
        case localizedName = "localized_name"
        case the1_Pick = "1_pick"
        case the1_Win = "1_win"
        case the2_Pick = "2_pick"
        case the2_Win = "2_win"
        case the3_Pick = "3_pick"
        case the3_Win = "3_win"
        case the4_Pick = "4_pick"
        case the4_Win = "4_win"
        case the5_Pick = "5_pick"
        case the5_Win = "5_win"
        case the6_Pick = "6_pick"
        case the6_Win = "6_win"
        case the7_Pick = "7_pick"
        case the7_Win = "7_win"
        case the8_Pick = "8_pick"
        case the8_Win = "8_win"
        case turboPicks = "turbo_picks"
        case turboPicksTrend = "turbo_picks_trend"
        case turboWINS = "turbo_wins"
        case turboWINSTrend = "turbo_wins_trend"
        case proPick = "pro_pick"
        case proWin = "pro_win"
        case proBan = "pro_ban"
        case pubPick = "pub_pick"
        case pubPickTrend = "pub_pick_trend"
        case pubWin = "pub_win"
        case pubWinTrend = "pub_win_trend"
    }
}

enum AttackType: String, Codable {
    case melee = "Melee"
    case ranged = "Ranged"
}

enum PrimaryAttr: String, Codable {
    case agi = "agi"
    case all = "all"
    case int = "int"
    case str = "str"
}

enum Role: String, Codable {
    case carry = "Carry"
    case disabler = "Disabler"
    case durable = "Durable"
    case escape = "Escape"
    case initiator = "Initiator"
    case nuker = "Nuker"
    case pusher = "Pusher"
    case support = "Support"
}

typealias Heroes = [HeroesData]

