//
//  ContentView.swift
//  Elva
//
//  Created by Arthur Guiot on 6/1/22.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: MarkdownDocument
    @StateObject var stats = Stats()
    var body: some View {
        VStack(spacing: 0) {
            EditorView(text: $document.content)
            EditorUtilView()
        }
        .environmentObject(stats)
        .frame(minWidth: 400, minHeight: 225)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(MarkdownDocument()))
    }
}
