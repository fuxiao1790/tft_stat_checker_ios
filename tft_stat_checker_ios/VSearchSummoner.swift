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
                .font(.system(.title))
            
            Text(self.summonerRankedData.rankDisplayText)
                .font(.system(.body))
            
            Text(self.summonerRankedData.winRateDisplayText)
                .font(.system(.body))
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
    
    // VIEW //
    var loading : some View {
        Text("Loading")
    }
    
    var unseen : some View {
        Text("YOU CAN'T SEE ME")
    }
    
    func getTraitBackgroundByStyle(style : Int) -> LinearGradient {
        switch style {
            case 1: return LinearGradient(gradient: Gradient(colors: [Color(rgb: 0xA1785D), Color(rgb: 0xCA9372)]), startPoint: .top, endPoint: .bottom)
            case 2: return LinearGradient(gradient: Gradient(colors: [Color(rgb: 0x707070), Color(rgb: 0xA0A0A0)]), startPoint: .top, endPoint: .bottom)
            case 3, 4: return LinearGradient(gradient: Gradient(colors: [Color(rgb: 0xC28A27), Color(rgb: 0xFFB93B)]), startPoint: .top, endPoint: .bottom)
            default: return LinearGradient(gradient: Gradient(colors: [Color(rgb: 0xA1785D), Color(rgb: 0xCA9372)]), startPoint: .top, endPoint: .bottom)
        }
    }
    
    func getUnitBorderColorByTier(tier : Int) -> Color {
        switch tier {
            case 0: return Color(rgb: 0x606060)
            case 1: return Color(rgb: 0x11B288)
            case 2: return Color(rgb: 0x207AC7)
            case 3: return Color(rgb: 0xC440DA)
            case 4: return Color(rgb: 0xFFB93B)
            case 5: return Color(rgb: 0xFFFFFF)
            default: return Color(rgb: 0x606060)
        }
    }
    
    var loaded : some View {
        HStack() {
            Text(String(self.matchData.placement))
                .font(.system(.title))
                .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
            VStack(alignment: .leading){
                // list of units
                HStack() {
                    ForEach(self.matchData.units) { (unit : MUnitData) in
                        Image(unit.characterID.lowercased())
                            .resizable()
                            .border(Color.purple, width: 5)
                            .cornerRadius(4)
                            .frame(width: 64, height: 64)
                    }
                }
                // list of traits
                HStack() {
                    ForEach(self.matchData.traits) { (trait : MTraitData) in
                        VStack() {
                            Image(trait.name.lowercased())
                                .resizable()
                                .frame(width: 24, height: 24)
                        } // VStack attrs
                            .padding(EdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6))
                            .background(Color.init(UIColor.systemGray3))
                            .cornerRadius(4)
                        // END OF VStack
                    }
                }
                HStack() {
                    // game time
                    Text(String(self.matchData.gameDateTime))
                        .font(.system(.body))
                    
                    Spacer()
                    
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

extension Color {
    init(rgb: Int) {
        self.init(
            red: Double((rgb >> 16) & 0xFF),
            green: Double((rgb >> 8) & 0xFF),
            blue: Double(rgb & 0xFF)
        )
    }
}
