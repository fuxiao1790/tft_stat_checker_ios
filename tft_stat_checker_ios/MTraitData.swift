//
//  MTraitData.swift
//  tft_stat_checker_ios
//
//  Created by Provalue on 2020-03-05.
//  Copyright © 2020 fuxiao. All rights reserved.
//

import Foundation

class MTraitData {
    var name : String = ""
    var numUnits : Int = 0
    var style : Int = 0
    var tierCurrent : Int = 0
    var tierTotal : Int = 0
    
    init(data : [String : Any]) {
        guard let name = data["name"] as? String else { return }
        guard let numUnits = data["num_units"] as? Int else { return }
        guard let style = data["style"] as? Int else { return }
        guard let tierCurrent = data["tier_current"] as? Int else { return }
        guard let tierTotal = data["tier_total"] as? Int else { return }
        
        self.name = name
        self.numUnits = numUnits
        self.style = style
        self.tierCurrent = tierCurrent
        self.tierTotal = tierTotal
    }
}
