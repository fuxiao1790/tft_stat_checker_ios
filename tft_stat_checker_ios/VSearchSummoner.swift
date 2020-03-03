    //
//  ContentView.swift
//  tft_stat_checker_ios
//
//  Created by fuxiao on 2020-02-27.
//  Copyright © 2020 fuxiao. All rights reserved.
//

import SwiftUI

struct VSearchSummoner : View {
    var summonerDataVM = VMSummonerData()
    var body: some View {
        VStack() {
            Text(summonerDataVM.summonerData.name)
            Text("Dummy text")
            Button(
                action: { self.summonerDataVM.fetchSummonerData(summonerName: "appearofflinemod", platform: "NA")},
                label: { Text("fetch data") }
            )
        }
    }
}

class VMSummonerData : ObservableObject {
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
