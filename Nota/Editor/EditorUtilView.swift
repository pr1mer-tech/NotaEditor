//
//  EditorUtilView.swift
//  Nota
//
//  Created by Arthur Guiot on 6/13/22.
//

import SwiftUI

struct EditorUtilView: View {
    @EnvironmentObject var document: MarkdownDocument
    
    @State var showDetails = false
    
    var body: some View {
        HStack {
            if document.networkActivity {
                ProgressView("Thinking...")
                    .progressViewStyle(.horizontal)
            }
            Spacer()
            Text("\(document.content.numberOfWords) words")
                .onTapGesture {
                    showDetails.toggle()
                    self.document.process()
                }
                .popover(isPresented: $showDetails, arrowEdge: .top) {
                    List {
                        Section("Counter") {
                            InfoRow(label: "Words", value: document.content.numberOfWords)
                            InfoRow(label: "Tokens", value: document.tokens)
                            InfoRow(label: "Paragraphs", value: document.paragraph)
                            InfoRow(label: "Sentences", value: document.sentences)
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
