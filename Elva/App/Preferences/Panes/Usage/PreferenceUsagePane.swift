//
//  PreferenceUsagePane.swift
//  Elva
//
//  Created by Arthur Guiot on 6/27/22.
//

import SwiftUI
import Preferences
struct PreferenceUsagePane: View {
    
    @Preference(\.completionUsage) var tokenUsage
    
    var body: some View {
        Settings.Container(contentWidth: 450) {
            Settings.Section(title: "Usage") {
                ProgressView(value: Double(tokenUsage) / 50000)
            }
        }
        
    }
}

struct PreferenceUsagePane_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceUsagePane()
    }
}
