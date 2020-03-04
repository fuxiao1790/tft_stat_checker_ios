//  ContentView.swift
//  tft_stat_checker_ios
//
//  Created by fuxiao on 2020-02-27.
//  Copyright © 2020 fuxiao. All rights reserved.
//

import SwiftUI

struct VSearchSummoner : View {
    // USER INPUT //
    @State private var searchText : String = ""
    @State private var searchPlatform : String = "NA"
    
    // UI CONTROLL //
    @State private var isLoadingData : Bool = false // prevent new api calls when there is already an api call pending
    @State private var showPlatformPicker : Bool = false
    
    // MODELS //
    @State private var summonerData : MSummonerData = MSummonerData()
    @State private var summonerRankedData : MSummonerRankedData = MSummonerRankedData()
    @State private var matchHistoryIDList : MMatchHistoryIDList = MMatchHistoryIDList()
    
    func fetchSummonerdata() {
        if (!self.isLoadingData) {
            summonerData.getSummonerByName(
                summonerName: self.searchText,
                platform: self.searchPlatform,
                onComplete: { (status) in
                    if (status) {
                        self.fetchSummonerRankedData()
                        self.fetchmatchHistoryIDList()
                    }
                }
            )
        }
    }
    
    func fetchSummonerRankedData() {
        self.summonerRankedData.getSummonerRankById(
            id: self.summonerData.id,
            platform: self.searchPlatform,
            onComplete: { (status) in
                self.isLoadingData = false
                if (status) {
                    // todo: ??
                }
            }
        )
    }
    
    func fetchmatchHistoryIDList() {
        self.matchHistoryIDList.getMatchHistoryIDListByPUUID(
            puuid: self.summonerData.puuid,
            platform: self.searchPlatform,
            onComplete: { (status) in
                self.isLoadingData = false
                if (status) {
                    // todo: inject data into list
                }
            }
        )
    }
    
    func togglePlatformPicker() {
        self.showPlatformPicker.toggle()
    }
    
    var body : some View {
        VStack() {
            HStack() {
                
                TextField("Summoner Name", text: $searchText)
                    .padding(EdgeInsets(top: 6, leading: 24, bottom: 6, trailing: 12))
                    .background(Color.gray)
                    .cornerRadius(36)
                
                Button(
                    action: { self.togglePlatformPicker() },
                    label: { Text(self.searchPlatform) }
                )
                    .padding(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                    .background(Color.gray)
                    .cornerRadius(36)
                    .sheet(
                        isPresented: $showPlatformPicker,
                        content: {
                            VPlatformPicker(
                                toggleVisibility: self.togglePlatformPicker,
                                initialSelected: self.searchPlatform
                            )
                        }
                    )
                
            }.padding(EdgeInsets(top: 12, leading: 12, bottom: 0, trailing: 12))
            
            Divider()
            
            
            
            Spacer()
        }
    }
}

struct VSearchSummoner_Previews: PreviewProvider {
    static var previews: some View {
        VSearchSummoner()
    }
}
