//
//  ContentView.swift
//  Elva
//
//  Created by Arthur Guiot on 6/1/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var document: MarkdownDocument
    
    @State var showInspector = false
    
    var body: some View {
        SplitView(showDetail: $showInspector) {
            EditorView()
            SmartPane()
                .frame(maxHeight: .infinity)
                .visualEffect(material: .sidebar)
        }
        .toolbar {
            Spacer()
            Button(action: { showInspector.toggle() }) {
                Label("Toggle Inspector", systemImage: "sidebar.right")
            }
        }
        .environmentObject(document)
        .frame(minWidth: 400, minHeight: 225)
    }
}
