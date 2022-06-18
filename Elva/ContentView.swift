//
//  ContentView.swift
//  Elva
//
//  Created by Arthur Guiot on 6/1/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var document: MarkdownDocument
    @ObservedObject var toolbar: ToolbarStateManager
    
    var body: some View {
        SplitView(showDetail: toolbar.showInspector) {
            EditorView()
            SmartPane()
                .frame(maxHeight: .infinity)
                .visualEffect(material: .sidebar)
        }
        .toolbar {
            Spacer()
            Button(action: { toolbar.showInspector.toggle() }) {
                Label("Toggle Inspector", systemImage: "sidebar.right")
            }
        }
        .environmentObject(document)
        .frame(minWidth: 400, minHeight: 225)
    }
}
