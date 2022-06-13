//
//  AttributedStringKeys.swift
//  EditorCore
//
//  Created by Arthur Guiot on 6/13/22.
//

import Foundation

extension NSAttributedString.Key {
    static let gptCompletion = NSAttributedString.Key("_gptCompletion")
}

extension NSAttributedString {
    var isGPTCompletion: Bool {
        guard self.string.count > 0 else { return false }
        return self.attribute(.gptCompletion, at: 0, effectiveRange: nil) != nil
    }
}
