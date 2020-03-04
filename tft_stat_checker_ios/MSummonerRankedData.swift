//
//  SummonerRankedData.swift
//  tft_stat_checker_ios
//
//  Created by Provalue on 2020-03-03.
//  Copyright © 2020 fuxiao. All rights reserved.
//

import Foundation

class MSummonerRankedData {
    var leagueId : String = ""
    var queueType : String = ""
    var tier : String = ""
    var rank : String = ""
    var summonerId : String = ""
    var summonerName: String = ""
    var leaguePoints : Int = 0
    var wins : Int = 0
    var losses : Int = 0
    var veteran : Bool = false
    var inactive : Bool = false
    var freshBlood : Bool = false
    var hotStreak : Bool = false
    var rankDisplayText : String = ""
    
    func getSummonerRankById(id : String, platform : String, onComplete: @escaping (Bool) -> Void) {
        if (id.count == 0 || platform.count == 0) {
            onComplete(false)
        }
        
        let platformURL : String = CONFIG.getPlatformURLByName(platform: platform)
        let route : String = "/tft/league/v1/entries/by-summoner/"
        let data : String = id
        
        let urlString : String = platformURL + route + data
        let url : URL = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.addValue(CONFIG.API_KEY, forHTTPHeaderField: "X-Riot-Token")
        
        print(urlString)
        
        URLSession.shared.dataTask(
            with: request,
            completionHandler: {(data: Data?, response: URLResponse?, error: Error?) in
                if let data = data {
                    do {
                        guard let jsonArray : [Any] = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] else { onComplete(false); return }
                        guard let json : [String:Any] = jsonArray[0] as? [String : Any] else { onComplete(false); return }
                        
                        guard let leagueId = json["leagueId"] as? String else { onComplete(false); return }
                        guard let queueType = json["queueType"] as? String else { onComplete(false); return }
                        guard let tier = json["tier"] as? String else { onComplete(false); return }
                        guard let rank = json["rank"] as? String else { onComplete(false); return }
                        guard let summonerName = json["summonerName"] as? String else { onComplete(false); return }
                        guard let summonerId = json["summonerId"] as? String else { onComplete(false); return }
                        guard let leaguePoints = json["leaguePoints"] as? Int else { onComplete(false); return }
                        guard let wins = json["wins"] as? Int else { onComplete(false); return }
                        guard let losses = json["losses"] as? Int else { onComplete(false); return }
                        guard let veteran = json["veteran"] as? Bool else { onComplete(false); return }
                        guard let inactive = json["inactive"] as? Bool else { onComplete(false); return }
                        guard let freshBlood = json["freshBlood"] as? Bool else { onComplete(false); return }
                        guard let hotStreak = json["hotStreak"] as? Bool else { onComplete(false); return }

                        self.leagueId = leagueId
                        self.queueType = queueType
                        self.tier = tier
                        self.rank = rank
                        self.summonerName = summonerName
                        self.summonerId = summonerId
                        self.leaguePoints = leaguePoints
                        self.wins = wins
                        self.losses = losses
                        self.veteran = veteran
                        self.inactive = inactive
                        self.freshBlood = freshBlood
                        self.hotStreak = hotStreak
                        self.rankDisplayText = "\(self.tier) \(self.rank) \(String(self.leaguePoints)) LP"
                        
                        print(json)
                        
                        onComplete(true)
                    } catch {
                        print(error)
                        onComplete(false)
                    }
                } else {
                    onComplete(false)
                }
            } // completionHandler
        ).resume()
    }
}
