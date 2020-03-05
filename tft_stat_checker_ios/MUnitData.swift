//
//  MUnitData.swift
//  tft_stat_checker_ios
//
//  Created by Provalue on 2020-03-05.
//  Copyright © 2020 fuxiao. All rights reserved.
//

import Foundation

class MUnitData {
    var characterID : String = ""
    var name : String = ""
    var rarity : Int = 0
    var tier : Int = 0
    var items : [Int] = []
    
    init(data : [String : Any]) {
        guard let characterID = data["character_id"] as? String else { return }
        guard let name = data["name"] as? String else { return }
        guard let rarity = data["rarity"] as? Int else { return }
        guard let tier = data["tier"] as? Int else { return }
        guard let items = data["items"] as? [Int] else { return }
        
        self.characterID = characterID
        self.name = name
        self.rarity = rarity
        self.tier = tier
        self.items = items
    }
}
