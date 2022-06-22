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
        VStack {
            SelectionWordsView(words: document.selecting?.numberOfWords ?? 0)
                .padding()
        }
    }
}

struct InstantModification_Previews: PreviewProvider {
    static var previews: some View {
        InstantModification()
    }
}
