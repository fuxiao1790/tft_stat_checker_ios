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
    
    func getSummonerRankById(id : String, platform : String, onComplete: (Bool) -> Void) {
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
        
        URLSession.shared.dataTask(
            with: request,
            completionHandler: {(data: Data?, response: URLResponse?, error: Error?) in
                if let data = data {
                    do {
                        guard let json:[String:Any] = try JSONSerialization.jsonObject(with : data, options : []) as? [String : Any] else {return}
                        
                        guard let leagueId = json["leagueId"] as? String else {return}
                        guard let queueType = json["queueType"] as? String else {return}
                        guard let tier = json["tier"] as? String else {return}
                        guard let rank = json["rank"] as? String else {return}
                        guard let summonerId = json["summonerId"] as? Int else {return}
                        guard let summonerName = json["summonerName"] as? Int else {return}
                        
                        self.id = id;
                        self.accountId = accountId;
                        self.puuid = puuid;
                        self.name = name;
                        self.profileIconId = profileIconId;
                        self.summonerLevel = summonerLevel;
                        
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
