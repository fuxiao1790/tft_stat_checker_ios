//  ContentView.swift
//  tft_stat_checker_ios
//
//  Created by fuxiao on 2020-02-27.
//  Copyright © 2020 fuxiao. All rights reserved.
//

import SwiftUI

struct VSearchSummoner : View {
    @State private var searchText : String = "" // user input
    @State private var searchPlatform : String = "" // user input
    
    @State private var isLoadingData : Bool = false // prevent new api calls when there is already an api call pending
    @State private var showSearchResult : Bool = false // display search result
    
    @State private var summonerData : MSummonerData = MSummonerData()
    @State private var summonerRankedData : MSummonerRankedData = MSummonerRankedData()
    
    func fetchSummonerdata(name : String, platform : String) {
        if (!self.isLoadingData) {
            self.isLoadingData = true
            self.showSearchResult = false
            summonerData.getSummonerByName(
                summonerName: name,
                platform: platform,
                onComplete: { (status) in
                    if (status) {
                        self.fetchSummonerRankedData()
                    } else {
                        self.showSearchResult = false
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
                    self.showSearchResult = true
                } else {
                    self.showSearchResult = false
                }
            }
        )
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                TextField("Enter Summoner Name", text: $searchText)
                TextField("Enter Platform", text: $searchPlatform)
                Button(
                    action: { self.fetchSummonerdata(name : self.searchText, platform : self.searchPlatform) },
                    label: { Text("print text") }
                )
            }
            
            if (self.showSearchResult) {
                Text("Search Result")
                Text(self.summonerData.name)
                Text(String(self.summonerData.summonerLevel))
                Text(self.summonerData.id)
                Text(self.summonerData.accountId)
                Text(self.summonerData.puuid)
            } else if (self.isLoadingData) {
                Text("Loading Data")
            }
        }
    }
}
