//
//  InstantModification.swift
//  Elva
//
//  Created by Arthur Guiot on 6/22/22.
//

import SwiftUI

struct InstantModification: View {
    
    @EnvironmentObject var document: MarkdownDocument
    
    @StateObject var editionController = EditionController()
    
    var body: some View {
        List {
            SelectionWordsView(words: document.selecting?.numberOfWords ?? 0)
                .onChange(of: document.selecting) { _ in
                    editionController.modification = nil
                }
            Section("Quick Actions") {
                Group {
                    AsyncButton {
                        try await editionController.edit(text: document.selecting!, with: "Fix the spelling mistakes")
                    } label: {
                        Text("Fix spelling")
                    }
                    RephraseButton(controller: editionController)
                }
                .disabled(document.selecting?.numberOfWords ?? 0 < 5)
            }
            if let preview = editionController.modification {
                Spacer()
                Section("Preview") {
                    TextChangePreview(oldText: document.selecting ?? "", newText: preview)
                
                    Button {
                        document.selectionReplacement = preview
                    } label: {
                        Text("Validate")
                            .frame(maxWidth: .infinity)
                    }

                }
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
