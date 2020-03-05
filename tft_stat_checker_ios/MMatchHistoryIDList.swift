//
//  MMatchHistoryIDList.swift
//  tft_stat_checker_ios
//
//  Created by Provalue on 2020-03-04.
//  Copyright © 2020 fuxiao. All rights reserved.
//

import Foundation

class MMatchHistoryIDList {
    var idList : [String] = []
    
    func getMatchHistoryIDListByPUUID(puuid : String, platform : String, onComplete: @escaping (Bool) -> Void) {
        if (puuid.count == 0 || platform.count == 0) {
            onComplete(false)
        }
        let platformURL : String = CONFIG.getRegionURLByName(platform: platform)
        let route : String = "/tft/match/v1/matches/by-puuid/"
        let data : String = puuid + "/ids?" + "count=100"
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
                        print(data)
                        guard let idList : [String] = try JSONSerialization.jsonObject(with : data, options : []) as? [String] else { onComplete(false); return; }
                        print(idList)
                        self.idList = idList
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
