//
//  VMSearchSummoner.swift
//  tft_stat_checker_ios
//
//  Created by Provalue on 2020-03-03.
//  Copyright © 2020 fuxiao. All rights reserved.
//

import Foundation

class VMSearchSummoner : ObservableObject {
    var summonerData : MSummonerData = MSummonerData()
    
    func fetchSummonerData(summonerName : String, platform : String) {
        summonerData.getSummonerByName(
            summonerName: summonerName,
            platform: platform,
            onComplete: {(status : Bool) in
                print(self.summonerData.name)
            }
        )
    }
}
