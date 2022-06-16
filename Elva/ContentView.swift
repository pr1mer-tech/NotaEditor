//
//  ContentView.swift
//  Elva
//
//  Created by Arthur Guiot on 6/1/22.
//

import SwiftUI

struct ContentView: View {
    @Binding var content: String
    @StateObject var manager: DocumentStateManager
    
    @State var showInspector = false
    
    var body: some View {
        SplitView {
            EditorView(content: $content)
            SmartPane()
                .frame(minWidth: 200, idealWidth: 300, maxWidth: .infinity, maxHeight: .infinity)
                .visualEffect(material: .sidebar)
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
        ContentView(content: .constant(""), manager: DocumentStateManager())
    }
}
