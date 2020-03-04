//
//  VPlatformPicker.swift
//  tft_stat_checker_ios
//
//  Created by Provalue on 2020-03-04.
//  Copyright © 2020 fuxiao. All rights reserved.
//

import SwiftUI

struct VPlatformPicker: View {
    private let platforms : [String]
    private var toggleVisibility : () -> Void
    @State private var selected : String = ""
    
    init(toggleVisibility : @escaping () -> Void, initialSelected : String) {
        self.platforms = CONFIG.PLATFORM_LIST
        self.toggleVisibility = toggleVisibility
        self.selected = initialSelected
    }
    
    func cancelOnPress() {
        self.toggleVisibility()
    }
    
    func saveOnPress() {
        self.toggleVisibility()
    }
    
    func naOnPress() {
        self.selected = "NA"
    }
    
    func euOnPress() {
        self.selected = "EU"
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
            
            Button(
                action: self.naOnPress,
                label: { Text("NA") }
            )
            
            Button(
                action: self.euOnPress,
                label: { Text("EU") }
            )
            
            Spacer()
        }
    }
}
