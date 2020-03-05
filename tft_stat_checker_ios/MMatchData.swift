//
//  MMatchData.swift
//  tft_stat_checker_ios
//
//  Created by Provalue on 2020-03-05.
//  Copyright © 2020 fuxiao. All rights reserved.
//

import Foundation


class MMatchData : ObservableObject {
    
    // player data to display in match history list
    @Published var Units : [String] = []
    @Published var Traits : [String] = []
    @Published var placement : String = ""
    @Published var setNumber : Int = 0
    @Published var gameDateTime : Int = 0
    @Published var gameLength : Int = 0
    
    // raw data
    var participantsIDList : [String] = []
    var participantsData : [MParticipantData] = []
    
    func getMatchDataByMatchID(id : String, platform : String, puuid : String, onComplete: @escaping (Bool) -> Void) {
        if (id.count == 0 || platform.count == 0) {
            onComplete(false)
        }
        let platformURL : String = CONFIG.getRegionURLByName(platform: platform)
        let route : String = "/tft/match/v1/matches/"
        let data : String = id
        let urlString = platformURL + route + data
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.addValue(CONFIG.API_KEY, forHTTPHeaderField: "X-Riot-Token")
        
        print(urlString)
        
        URLSession.shared.dataTask(
            with: request,
            completionHandler: {(data: Data?, response: URLResponse?, error: Error?) in
                if let data = data {
                    do {
                        guard let json : [String:Any] = try JSONSerialization.jsonObject(with : data, options : []) as? [String:Any] else { onComplete(false); return; }
                        print(json)
                        
                        guard let metadata : [String : Any] = json["metadata"] as? [String : Any] else { onComplete(false); return; }
                        guard let info : [String : Any] = json["info"] as? [String : Any] else { onComplete(false); return; }
                        
                        guard let participantPUUIDList : [String] = metadata["participants"] as? [String] else { onComplete(false); return; }
                        let participantsIDList = participantPUUIDList
                        
                        guard let participantJSONArray : [[String : Any]] = info["participants"] as? [[String : Any]] else { onComplete(false); return; }
                        
                        let participantsData = participantJSONArray.map{ MParticipantData(data: $0) }
                        
                        DispatchQueue.main.async {
                            self.participantsIDList = participantsIDList
                            self.participantsData = participantsData
                            onComplete(true)
                        }
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
