//
//  VMain.swift
//  tft_stat_checker_ios
//
//  Created by Provalue on 2020-03-04.
//  Copyright © 2020 fuxiao. All rights reserved.
//

import Foundation
import SwiftUI

struct VMain : View {
    var body : some View {
        TabView {
            VSearchSummoner()
                .font(.title)
                .tabItem({
                    Image(systemName: "circle")
                    Text("Search")
                })
                .tag(0)
            
            VChampions()
                .font(.title)
                .tabItem({
                    Image(systemName: "square")
                    Text("Champions")
                })
                .tag(1)
            
            VItems()
                .font(.title)
                .tabItem({
                    Image(systemName: "triangle")
                    Text("Items")
                })
                .tag(2)
        }
    }
}

struct VMain_Previews: PreviewProvider {
    static var previews: some View {
        VMain()
    }
}
