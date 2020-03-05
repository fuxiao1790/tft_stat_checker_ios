//
//  MParticipantData.swift
//  tft_stat_checker_ios
//
//  Created by Provalue on 2020-03-05.
//  Copyright © 2020 fuxiao. All rights reserved.
//

import Foundation

class MParticipantData {
    var goldLeft : Int = 0
    var lastRound : Int = 0
    var level : Int = 0
    var placement : Int = 0
    var playersEliminated : Int = 0
    var totalDamageToPlayers : Int = 0
    var timeEliminated : Double = 0
    var puuid : String = ""
    var units : [MUnitData] = []
    var traits : [MTraitData] = []
    
    init(data : [String : Any]) {
        guard let goldLeft = data["gold_left"] as? Int else { return }
        guard let lastRound = data["last_round"] as? Int else { return }
        guard let level = data["level"] as? Int else { return }
        guard let placement = data["placement"] as? Int else { return }
        guard let playersEliminated = data["players_eliminated"] as? Int else { return }
        guard let puuid = data["puuid"] as? String else { return }
        guard let totalDamageToPlayers = data["total_damage_to_players"] as? Int else { return }
        guard let timeEliminated = data["time_eliminated"] as? Double else { return }
        
        guard let unitJSONList : [[String : Any]] = data["units"] as? [[String : Any]] else { return }
        let units = unitJSONList.map{ MUnitData(data: $0) }
        
        guard let traitJSONList : [[String : Any]] = data["traits"] as? [[String : Any]] else { return }
        let traits = traitJSONList.map{ MTraitData(data: $0) }
        
        self.goldLeft = goldLeft
        self.lastRound = lastRound
        self.level = level
        self.placement = placement
        self.playersEliminated = playersEliminated
        self.totalDamageToPlayers = totalDamageToPlayers
        self.timeEliminated = timeEliminated
        self.puuid = puuid
        self.units = units
        self.traits = traits
    }
}
