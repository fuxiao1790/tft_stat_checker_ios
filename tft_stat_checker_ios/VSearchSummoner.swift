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
    @ObservedObject private var summonerData : MSummonerData = MSummonerData()
    @ObservedObject private var summonerRankedData : MSummonerRankedData = MSummonerRankedData()
    @ObservedObject private var matchHistoryIDList : MMatchHistoryIDList = MMatchHistoryIDList()
    
    @State private var testing : Bool = false
    @State private var name : String = ""
    
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
                if (status) {
                    // todo: inject data into list
                }
            }
        )
    }
    
    func togglePlatformPicker() {
        self.showPlatformPicker.toggle()
    }
    
    // VIEW //
    var summonerCard : some View {
        VStack() {
            Text(self.summonerData.name)
            Text(self.summonerRankedData.rankDisplayText)
            Text(self.summonerRankedData.winRateDisplayText)
        }
    }
    
    var searchBar : some View {
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
                .shadow(radius: 2)
            // END OF HStack
            
        } // HStack attrs
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
        // END OF HStack
    }
    
    var matchHistoryList : some View {
        List {
            self.summonerCard
            ForEach(self.matchHistoryIDList.MatchIDList) { id in
                MatchHistoryItem(
                    matchID: id,
                    platform: self.searchPlatform,
                    summonerData : self.summonerData,
                    summonerRankedData : self.summonerRankedData
                )
            }
        }// List attrs
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .navigationBarItems(leading: self.searchBar)
        // END OF List
    }
    
    var body : some View {
        VStack() {
            self.searchBar
            Divider()
            self.matchHistoryList
            Spacer()
        }
    }
}

struct MatchHistoryItem : View {
    public static let LOADING : Int = 0
    public static let FAILED : Int = 1
    public static let UNSEEN : Int = 2
    public static let LOADED : Int = 3
    
    let matchID : MatchID
    let platform : String
    let summonerData : MSummonerData
    let summonerRankedData : MSummonerRankedData
    @State private var status : Int = MatchHistoryItem.UNSEEN
    @ObservedObject private var matchData : MMatchData = MMatchData()
    
    init(matchID : MatchID, platform : String, summonerData : MSummonerData, summonerRankedData : MSummonerRankedData) {
        self.matchID = matchID
        self.platform = platform
        self.summonerData = summonerData
        self.summonerRankedData = summonerRankedData
    }
    
    func onAppear() {
        if (self.status == MatchHistoryItem.UNSEEN) {
            self.status = MatchHistoryItem.LOADING
            self.matchData.getMatchDataByMatchID(
                id: self.matchID.stringID,
                platform: self.platform,
                puuid: self.summonerData.puuid,
                onComplete: { (status) in
                    if (status) {
                        self.status = MatchHistoryItem.LOADED
                    } else {
                        self.status = MatchHistoryItem.FAILED
                    }
                }
            )
            print("loading: \(self.matchID.stringID)")
        }
    }
    
    var loading : some View {
        Text("Loading")
    }
    
    var unseen : some View {
        Text("YOU CAN'T SEE ME")
    }
    
    var loaded : some View {
        HStack() {
            Text(String(self.matchData.placement))
                .font(.system(.body))
            VStack(){
                // list of units
                HStack() {
                    ForEach(self.matchData.units) { (unit : MUnitData) in
                        Text(unit.name)
                            .font(.system(.body))
                            .padding(EdgeInsets(top: 4, leading: 4, bottom: 10, trailing: 10))
                            .background(Color.init(UIColor.systemGray3))
                            .cornerRadius(4)
                    }
                }
                // list of traits
                HStack() {
                    // game time
                    Text(String(self.matchData.gameDateTime))
                        .font(.system(.body))
                    // game duration
                    Text(String(self.matchData.gameLength))
                        .font(.system(.body))
                }
            }
        }
    }
    
    var failed : some View {
        Text("Load Failed")
    }
    
    var body : some View {
        HStack() {
            if (self.status == MatchHistoryItem.LOADING) { self.loading }
            else if (self.status == MatchHistoryItem.UNSEEN) { self.unseen }
            else if (self.status == MatchHistoryItem.FAILED) { self.failed }
            else if (self.status == MatchHistoryItem.LOADED) { self.loaded }
        } //HStack attrs
            .onAppear(perform: self.onAppear)
        // END OF HStack
    }
}

struct VSearchSummoner_Previews: PreviewProvider {
    static var previews: some View {
        VSearchSummoner()
    }
}
