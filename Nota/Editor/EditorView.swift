//
//  EditorView.swift
//  Nota
//
//  Created by Arthur Guiot on 6/15/22.
//

import SwiftUI

struct EditorView: View {
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color.white
                EditorCoreView()
                    .frame(maxWidth: 600)
            }
            
            EditorUtilView()
        }
    }
}
