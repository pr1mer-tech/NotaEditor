//
//  StringDiff.swift
//  Elva
//
//  Created by Arthur Guiot on 6/24/22.
//

import Foundation
import AppKit
import TextDiff

extension String {
    func attributedDifference(from oldText: String) -> NSAttributedString {
        let diff = diff(text1: oldText, text2: self)
        let attr = NSMutableAttributedString()
        
        for delta in diff {
            switch delta {
            case .equal(let string):
                attr.append(.init(string: string))
            case .insert(let string):
                attr.append(.init(string: string, attributes: [
                    .underlineStyle: NSUnderlineStyle.single.rawValue,
                    .underlineColor: NSColor.systemGreen.withAlphaComponent(0.5)
                ]))
            case .delete(let string):
                attr.append(.init(string: string, attributes: [
                    .underlineColor: NSColor.systemRed.withAlphaComponent(0.5),
                    .underlineStyle: NSUnderlineStyle.single.rawValue,
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue
                ]))
            }
        }
        
        // Set body style
        attr.addAttributes([
            .font: NSFont.systemFont(ofSize: NSFont.systemFontSize),
            .foregroundColor: NSColor.labelColor
        ], range: NSRange(location: 0, length: attr.length))
        
        return attr
    }
}
