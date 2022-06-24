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
                    .backgroundColor: NSColor.systemGreen.withAlphaComponent(0.5)
                ]))
            case .delete(let string):
                attr.append(.init(string: string, attributes: [
                    .backgroundColor: NSColor.systemRed.withAlphaComponent(0.5),
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue
                ]))
            }
        }
        return attr
    }
}
