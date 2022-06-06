//
//  EditorCore-macOS.swift
//  EditorCore
//
//  Created by Christian Tietze on 2017-07-21.
//  Copyright © 2017 Rudd Fawcett. All rights reserved.
//

#if os(macOS)
import AppKit
import STTextView
public class EditorCore: STTextView {
    var storage: Storage = Storage() {
        didSet {
            self.textContentStorage.textStorage = storage
        }
    }
}
#endif
