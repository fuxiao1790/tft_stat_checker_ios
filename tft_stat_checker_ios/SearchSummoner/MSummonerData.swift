//
//  MSummonerData.swift
//  tft_stat_checker_ios
//
//  Created by fuxiao on 2020-02-28.
//  Copyright © 2020 fuxiao. All rights reserved.
//

import Foundation

class MSummonerData : ObservableObject {

    @Published var id : String
    @Published var accountId : String
    @Published var puuid : String
    @Published var name : String
    @Published var profileIconId : Int
    @Published var summonerLevel : Int
    
    init() {
        self.id = ""
        self.accountId = ""
        self.puuid = ""
        self.name = "dummy name"
        self.profileIconId = 1
        self.summonerLevel = 1
    }
    
    func getSummonerByName(summonerName : String, platform : String, onComplete : @escaping (Bool) -> Void) {
        let platformURL : String = CONFIG.getPlatformURLByName(platform: platform)
        let route : String = "/tft/summoner/v1/summoners/by-name"
        let data : String = "/" + summonerName + "?summonerName=" + summonerName
        let urlString = platformURL + route + data
        let session = URLSession.shared
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.addValue(CONFIG.API_KEY, forHTTPHeaderField: "X-Riot-Token")
        
        print(urlString)
        
        session.dataTask(
            with: request,
            completionHandler: {(data: Data?, response: URLResponse?, error: Error?) in
                if let data = data {
                    do {
                        guard let json:[String:Any] = try JSONSerialization.jsonObject(with : data, options : []) as? [String : Any] else {return}
                        
                        guard let id = json["id"] as? String else {return}
                        guard let accountId = json["accountId"] as? String else {return}
                        guard let puuid = json["puuid"] as? String else {return}
                        guard let name = json["name"] as? String else {return}
                        guard let profileIconId = json["profileIconId"] as? Int else {return}
                        guard let summonerLevel = json["summonerLevel"] as? Int else {return}
                        
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
                } // if
            } // completionHandler
        ).resume()
    }
}
