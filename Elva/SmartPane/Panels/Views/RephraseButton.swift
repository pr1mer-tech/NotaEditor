//
//  RephraseButton.swift
//  Elva
//
//  Created by Arthur Guiot on 6/23/22.
//

import SwiftUI

struct RephraseButton: View {
    
    @State var expanded = false
    
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
                Button {
                    // Simplify
                } label: {
                    Text("Simplify")
                        .frame(maxWidth: .infinity)
                }
                Button {
                    // Negate
                } label: {
                    Text("Negate")
                        .frame(maxWidth: .infinity)
                }
            }
            HStack {
                Button {
                    // Feynman
                } label: {
                    Text("Feynman")
                        .frame(maxWidth: .infinity)
                }
                Button {
                    // Agreeable
                } label: {
                    Text("Agreeable")
                        .frame(maxWidth: .infinity)
                }
            }
            HStack {
                Button {
                    // Legalize
                } label: {
                    Text("Legalize")
                        .frame(maxWidth: .infinity)
                }
                Button {
                    // Summarize
                } label: {
                    Text("Summarize")
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

struct RephraseButton_Previews: PreviewProvider {
    static var previews: some View {
        RephraseButton()
    }
}
