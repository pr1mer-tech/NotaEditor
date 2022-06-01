//
//  ContentView.swift
//  Elva
//
//  Created by Arthur Guiot on 6/1/22.
//

import SwiftUI

struct ContentView: View {
    @State var text = ""
    var body: some View {
        EditorView(text: $text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
