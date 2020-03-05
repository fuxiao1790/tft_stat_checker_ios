//
//  VPlatformPicker.swift
//  tft_stat_checker_ios
//
//  Created by Provalue on 2020-03-04.
//  Copyright © 2020 fuxiao. All rights reserved.
//

import SwiftUI

struct VPlatformPicker: View {
    private let platforms : [Platform]
    private var toggleVisibility : () -> Void
    @State private var selected : String = ""
    
    init(toggleVisibility : @escaping () -> Void, initialSelected : String) {
        self.platforms = CONFIG.PLATFORM_LIST.map{ Platform(name: $0) }
        self.toggleVisibility = toggleVisibility
        self.selected = initialSelected
    }
    
    func cancelOnPress() {
        self.toggleVisibility()
    }
    
    func saveOnPress() {
        self.toggleVisibility()
    }
    
    var body: some View {
        VStack() {
            HStack() {
                Button(
                    action: self.toggleVisibility,
                    label: { Text("Back") }
                )
                
                Spacer()
                
                Text("Select Region")
                    .bold()
                    .font(.headline)
                
                Spacer()
                
                Button(
                    action: self.toggleVisibility,
                    label: { Text("Save") }
                )
                
            }.padding(EdgeInsets(top: 12, leading: 18, bottom: 0, trailing: 18))
            
            Divider()
            
            List(self.platforms) { platform in
                PlatformItem(platform: platform)
            }
            
            Spacer()
        }
    }
}

struct PlatformItem : View {
    var platform : Platform
    init(platform : Platform) {
        self.platform = platform
    }
    var body : some View {
        Text(platform.name)
    }
}

struct Platform : Identifiable{
    var id : UUID
    var name : String
    
    init(name : String) {
        self.id = UUID()
        self.name = name
    }
}
