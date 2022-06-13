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
    
    var hasGPTCompletion: Bool {
        return GPTCompletionRange != nil
    }
    
    var GPTCompletionRange: NSRange? {
        var gptRange: NSRange? = nil
        self.enumerateAttributes(in: NSRange(location: 0, length: self.length)) { attributes, range, stop in
            guard  attributes.keys.contains(.gptCompletion) else { return }
            guard range.location != NSNotFound else { return }
            guard range.length > 0 else { return }
            gptRange = range
            stop.pointee = true
        }
        return gptRange
    }
}
