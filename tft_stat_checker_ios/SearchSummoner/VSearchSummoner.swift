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
    
    @State private var isLoadingData : Bool = false
    
    @State private var resultName : String = "Summoner Name" // search result summoner name
    
    @State private var showSearchResult : Bool = false //
    
    private var summonerData : MSummonerData = MSummonerData()
    
    func fetchSummonerdata(name : String, platform: String) {
        if (!self.isLoadingData) {
            self.isLoadingData = true
            summonerData.getSummonerByName(
                summonerName: name,
                platform: platform,
                onComplete: { (status) in
                    self.isLoadingData = false
                    if (status) {
                        self.showSearchResult = true
                        self.resultName = self.summonerData.name
                    } else {
                        self.showSearchResult = false
                        self.resultName = ""
                    }
                }
            )
        }
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
            
            Text("Search Result")
            Text(resultName)
        }
    }
}
