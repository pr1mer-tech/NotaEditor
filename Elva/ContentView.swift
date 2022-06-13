//
//  ContentView.swift
//  Elva
//
//  Created by Arthur Guiot on 6/1/22.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: MarkdownDocument
    
    var body: some View {
        EditorView(text: $document.content)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(MarkdownDocument()))
    }
}
