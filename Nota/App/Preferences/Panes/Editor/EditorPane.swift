//
//  EditorPane.swift
//  Nota
//
//  Created by Arthur Guiot on 29/08/2022.
//

import SwiftUI
import Preferences
struct EditorPane: View {
    
    @Preference(\.highlight_line) var highlightLine
    
    var body: some View {
        Settings.Container(contentWidth: 450) {
            Settings.Section(title: "Editor", bottomDivider: true, verticalAlignment: .top) {
                Toggle("Highlight current line", isOn: $highlightLine)
                Text("Decides whether the text view highlights the currently selected line.")
                    .preferenceDescription()
            }
        }
    }
}

struct EditorPane_Previews: PreviewProvider {
    static var previews: some View {
        EditorPane()
    }
}
