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
        self.summonerData.getSummonerByName(
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
    
    var summonerCard : some View {
        VStack() {
            Text(self.summonerData.name)
            Text(self.summonerRankedData.rankDisplayText)
            Text(self.summonerRankedData.winRateDisplayText)
        }
    }
    
    var body : some View {
        VStack() {
            
            HStack() {
                HStack() {
                    TextField("Summoner Name", text: $searchText)
                        .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                        .font(.body)
                    // END OF TextField
                    
                    Button(
                        action: { self.togglePlatformPicker() },
                        label: { Text(self.searchPlatform) }
                    ) // Button attrs
                        .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 10))
                        .background(Color.init(UIColor.systemGray4))
                        .cornerRadius(16)
                        .font(.body)
                        .sheet(
                            isPresented: $showPlatformPicker,
                            content: {
                                VPlatformPicker(
                                    toggleVisibility: self.togglePlatformPicker,
                                    initialSelected: self.searchPlatform
                                )
                            }
                        )
                    // END OF Button
                    
                    Button(
                        action: { self.fetchSummonerdata() },
                        label: { Text("Search") }
                    ) // Button attrs
                        .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 10))
                        .background(Color.init(UIColor.systemGray4))
                        .cornerRadius(16)
                        .font(.body)
                        .sheet(
                            isPresented: $showPlatformPicker,
                            content: {
                                VPlatformPicker(
                                    toggleVisibility: self.togglePlatformPicker,
                                    initialSelected: self.searchPlatform
                                )
                            }
                        )
                    // END OF Button
                    
                } // HStack attrs
                    .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 8))
                    .background(Color.init(UIColor.systemGray5))
                    .cornerRadius(36)
                // END OF HStack
                
            } // HStack attrs
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
            // END OF HStack
            
            Text(self.summonerData.name)
            Text(self.summonerRankedData.rankDisplayText)
            Text(self.summonerRankedData.winRateDisplayText)
            
            Spacer()
        }
    }
}

struct VSearchSummoner_Previews: PreviewProvider {
    static var previews: some View {
        VSearchSummoner()
    }
}


//            List {
//                self.summonerCard
//                Text("Large Title").font(.largeTitle)
//                Text("Title").font(.title)
//                Text("Headline").font(.headline)
//                Text("SubHeadline").font(.subheadline)
//                Text("Body").font(.body)
//                Text("Callout").font(.callout)
//                Text("FootNote").font(.footnote)
//            }
