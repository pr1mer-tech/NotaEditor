//
//  RephraseButton.swift
//  Nota
//
//  Created by Arthur Guiot on 6/23/22.
//

import SwiftUI

struct RephraseButton: View {
    
    @State var expanded = false
    @EnvironmentObject var document: MarkdownDocument
    @ObservedObject var controller: EditionController
    
    var body: some View {
        Button {
            withAnimation(.easeOut) {
                expanded.toggle()
            }
        } label: {
            ZStack {
                HStack {
                    Image(systemName: "chevron.right")
                        .rotationEffect(expanded ? .degrees(90) : .zero)
                    Spacer()
                }
                Text("Rephrase")
            }
            .frame(maxWidth: .infinity)
        }
        if expanded {
            HStack {
                AsyncButton {
                    try await controller.edit(text: document.selecting!, with: "Rephrase by simplifying")
                } label: {
                    Text("Simplify")
                }
                AsyncButton {
                    try await controller.edit(text: document.selecting!, with: "Rephrase by negating")
                } label: {
                    Text("Negate")
                }
            }
            HStack {
                AsyncButton {
                    try await controller.edit(text: document.selecting!, with: "Rephrase using Feynman technique")
                } label: {
                    Text("Feynman")
                }
                AsyncButton {
                    try await controller.edit(text: document.selecting!, with: "Rephrase it to be agreeable")
                } label: {
                    Text("Agreeable")
                }
            }
            HStack {
                AsyncButton {
                    try await controller.edit(text: document.selecting!, with: "Rephrase it in a legalized way")
                } label: {
                    Text("Legalize")
                }
                AsyncButton {
                    try await controller.edit(text: document.selecting!, with: "Summarize it")
                } label: {
                    Text("Summarize")
                }
            }
        }
    }
}

struct RephraseButton_Previews: PreviewProvider {
    static var previews: some View {
        RephraseButton(controller: EditionController())
    }
}
