//
//  EditorUtilView.swift
//  Elva
//
//  Created by Arthur Guiot on 6/13/22.
//

import SwiftUI

struct EditorUtilView: View {
    
    @EnvironmentObject var stats: Stats
    
    var body: some View {
        HStack {
            if stats.networkActivity {
                ProgressView("Thinking...")
                    .progressViewStyle(.horizontal)
            }
            Spacer()
            Text("\(stats.wordCount) words")
        }
        .padding(.all, 5)
        .frame(height: 25)
    }
}

struct EditorUtilView_Previews: PreviewProvider {
    static var previews: some View {
        EditorUtilView()
    }
}
