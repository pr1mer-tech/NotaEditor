//
//  EditorView.swift
//  Elva
//
//  Created by Arthur Guiot on 6/15/22.
//

import SwiftUI

struct EditorView: View {
    @Binding var content: String    
    var body: some View {
        VStack(spacing: 0) {
            EditorCoreView(text: $content)
            EditorUtilView(content: $content)
        }
    }
}
