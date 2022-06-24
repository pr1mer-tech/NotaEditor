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
    
    var body: some View {
        AttributedText(
            text: newText.attributedDifference(from: oldText)
        )
        .frame(height: 75)
        .cornerRadius(5)
    }
}

struct TextChangePreview_Previews: PreviewProvider {
    static var previews: some View {
        TextChangePreview(oldText:
                            "Mi name are Arthur",
                          newText: "My name is Arthur")
    }
}
