//
//  TextRange.swift
//  EditorCore
//
//  Created by Arthur Guiot on 6/9/22.
//

import Foundation
import STTextView
import AppKit

extension STTextView {
    func nsRange(from textRange: NSTextRange) -> NSRange {
        let offset = textContentStorage.offset(from: textLayoutManager.documentRange.location, to: textRange.location)
        let length = textContentStorage.offset(from: textRange.location, to: textRange.endLocation)
        return NSRange(location: offset, length: length)
    }
}
