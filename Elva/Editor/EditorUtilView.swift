//
//  EditorUtilView.swift
//  Elva
//
//  Created by Arthur Guiot on 6/13/22.
//

import SwiftUI

struct EditorUtilView: View {
    @Binding var content: String
    
    @EnvironmentObject var manager: DocumentStateManager
    
    @State var showDetails = false
    
    var body: some View {
        HStack {
            if manager.networkActivity {
                ProgressView("Thinking...")
                    .progressViewStyle(.horizontal)
            }
            Spacer()
            Text("\(content.numberOfWords) words")
                .onTapGesture {
                    showDetails.toggle()
                    self.manager.process(content: content)
                }
                .popover(isPresented: $showDetails, arrowEdge: .top) {
                    List {
                        Section("Counter") {
                            InfoRow(label: "Words", value: content.numberOfWords)
                            InfoRow(label: "Tokens", value: manager.tokens)
                            InfoRow(label: "Paragraphs", value: manager.paragraph)
                            InfoRow(label: "Sentences", value: manager.sentences)
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
        EditorUtilView(content: .constant(""))
    }
}
