//
//  EditorUtilView.swift
//  Elva
//
//  Created by Arthur Guiot on 6/13/22.
//

import SwiftUI

struct EditorUtilView: View {
    
    @EnvironmentObject var manager: DocumentManager
    
    @State var showDetails = false
    
    var body: some View {
        HStack {
            if manager.networkActivity {
                ProgressView("Thinking...")
                    .progressViewStyle(.horizontal)
            }
            Spacer()
            Text("\(manager.wordCount) words")
                .onTapGesture {
                    showDetails.toggle()
                }
                .popover(isPresented: $showDetails, arrowEdge: .bottom) {
                    List {
                        Section("Counter") {
                            InfoRow(label: "Words", value: manager.wordCount)
                            InfoRow(label: "Tokens", value: manager.tokens)
                        }
                    }
                }
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
