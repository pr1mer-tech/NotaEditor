//
//  ElvaApp.swift
//  Elva
//
//  Created by Arthur Guiot on 6/1/22.
//

import SwiftUI
@main
struct ElvaApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: MarkdownDocument()) { file in
            ContentView(content: file.$document.content, manager: DocumentManager())
        }
    }
}
