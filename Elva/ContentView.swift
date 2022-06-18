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
        SplitView(showDetail: $showInspector) {
            EditorView(content: $content)
            SmartPane()
                .frame(maxHeight: .infinity)
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
