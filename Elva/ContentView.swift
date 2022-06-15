//
//  ContentView.swift
//  Elva
//
//  Created by Arthur Guiot on 6/1/22.
//

import SwiftUI

struct ContentView: View {
    @Binding var content: String
    @StateObject var manager: DocumentManager
    
    @State var showInspector = false
    
    var body: some View {
        HSplitView {
            EditorView(content: $content)
            if showInspector {
                SmartPane()
                    .frame(minWidth: 200, idealWidth: 300, maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .toolbar {
            Button(action: { showInspector.toggle() }) {
                Label("Toggle Inspector", systemImage: "sidebar.right")
            }
        }
        .environmentObject(manager)
        .frame(minWidth: 400, minHeight: 225)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(content: .constant(""), manager: DocumentManager())
    }
}
