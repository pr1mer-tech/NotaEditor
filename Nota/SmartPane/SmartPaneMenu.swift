//
//  SmartPaneMenu.swift
//  Nota
//
//  Created by Arthur Guiot on 6/22/22.
//

import SwiftUI

enum SmartPanePanel {
    case instantModifications
}

struct SmartPaneMenu: View {
    @Binding var selected: SmartPanePanel
    var body: some View {
        HStack {
            Button {
                selected = .instantModifications
            } label: {
                Image(systemName: "brain")
                    .foregroundColor(selected == .instantModifications ? .accentColor : .gray)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .frame(height: 52) // Unified toolbar style
    }
}
