//
//  SmartPane.swift
//  Nota
//
//  Created by Arthur Guiot on 6/15/22.
//

import SwiftUI

struct SmartPane: View {
    
    @State var selected = SmartPanePanel.instantModifications
    
    var body: some View {
        VStack(spacing: 0) {
            SmartPaneMenu(selected: $selected)
            switch selected {
            case .instantModifications:
                InstantModification()
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}
