//
//  InstantModification.swift
//  Elva
//
//  Created by Arthur Guiot on 6/22/22.
//

import SwiftUI

struct InstantModification: View {
    
    @EnvironmentObject var document: MarkdownDocument
    
    var body: some View {
        List {
            SelectionWordsView(words: document.selecting?.numberOfWords ?? 0)
            Section("Quick Actions") {
                Group {
                    Button {
                        // Fix spelling
                    } label: {
                        Text("Fix spelling")
                            .frame(maxWidth: .infinity)
                    }
                    RephraseButton()
                }
                .disabled(document.selecting?.numberOfWords ?? 0 < 5)
            }
        }
        .listStyle(SidebarListStyle())
    }
}

struct InstantModification_Previews: PreviewProvider {
    static var previews: some View {
        InstantModification()
    }
}
