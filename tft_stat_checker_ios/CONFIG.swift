//
//  CONFIG.swift
//  tft_stat_checker_ios
//
//  Created by fuxiao on 2020-02-28.
//  Copyright © 2020 fuxiao. All rights reserved.
//

import Foundation

class CONFIG {
    static let API_KEY = "RGAPI-375d87ac-b115-475d-8ae4-eb81c399ddb0"
    static let PLATFORM_LIST = ["NA", "BR", "LA", "EUNE", "EUW", "TR", "RU", "JP", "KR", "OC"]
    
    static func getRegionURLByName(platform: String) -> String {
        switch(platform) {
            case "NA": return "https://americas.api.riotgames.com"
            case "BR": return "https://americas.api.riotgames.com"
            case "LA": return "https://americas.api.riotgames.com"
            case "EUNE": return "https://europe.api.riotgames.com"
            case "EUW": return "https://europe.api.riotgames.com"
            case "TR": return "https://europe.api.riotgames.com"
            case "RU": return "https://europe.api.riotgames.com"
            case "JP": return "https://asia.api.riotgames.com"
            case "KR": return "https://asia.api.riotgames.com"
            case "OC": return "https://asia.api.riotgames.com"
            default: return ""
        }
    }
    
    static func getPlatformURLByName(platform: String) -> String {
        switch(platform) {
            case "BR": return "https://br1.api.riotgames.com"
            case "EUNE": return "https://eun1.api.riotgames.com"
            case "EUW": return "https://euw1.api.riotgames.com"
            case "JP": return "https://jp1.api.riotgames.com"
            case "KR": return "https://kr.api.riotgames.com"
            case "LA": return "https://la1.api.riotgames.com"
            case "OC": return "https://oc1.api.riotgames.com"
            case "TR": return "https://tr1.api.riotgames.com"
            case "RU": return "https://ru.api.riotgames.com"
            case "NA": return "https://na1.api.riotgames.com"
            default: return ""
        }
    }
    
    static func getPlatformDisplayName(platform: String) -> String {
        switch(platform) {
            case "BR": return "Brazil"
            case "EUNE": return "EU Nordic / East"
            case "EUW": return "EW West"
            case "JP": return "Japan"
            case "KR": return "Korea"
            case "LA": return "Latin America"
            case "OC": return "Oceania"
            case "TR": return "Turkey"
            case "RU": return "Russia"
            case "NA": return "North America"
            default: return ""
        }
    }
}
