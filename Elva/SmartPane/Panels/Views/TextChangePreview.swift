//
//  TextChangePreview.swift
//  Elva
//
//  Created by Arthur Guiot on 6/24/22.
//

import SwiftUI

struct TextChangePreview: View {
    var oldText: String
    var newText: String
    
    @State var shouldPreview = true
    @State var attributed = NSAttributedString()
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            AttributedText(
                text: shouldPreview ? attributed : NSAttributedString(string: newText, attributes: [
                    .font: NSFont.systemFont(ofSize: NSFont.systemFontSize),
                    .foregroundColor: NSColor.labelColor
                ])
            )
            .frame(height: 75)
            .cornerRadius(5)
            Button {
                shouldPreview.toggle()
            } label: {
                Image(systemName: "square.filled.and.line.vertical.and.square")
                    .foregroundColor(shouldPreview ? .accentColor : .gray)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .task {
            (attributed, shouldPreview) = newText.attributedDifference(from: oldText)
        }
    }
}

struct TextChangePreview_Previews: PreviewProvider {
    static var previews: some View {
        TextChangePreview(oldText:
                            "Mi name are Arthur",
                          newText: "My name is Arthur")
    }
}
