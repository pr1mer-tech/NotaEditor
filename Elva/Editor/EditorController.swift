//
//  EditorController.swift
//  Elva
//
//  Created by Arthur Guiot on 6/1/22.
//

import SwiftUI
import EditorCore

class EditorController: NSViewController {
    var textView = EditorCore()
    let storage = Storage()
    
    override func loadView() {
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        
        let theme = Theme("system-minimal")
        storage.theme = theme
        textView.backgroundColor = theme.backgroundColor
        textView.insertionPointColor = theme.tintColor
        textView.autoresizingMask = [.width]
        textView.allowsUndo = true
        textView.layoutManager?.replaceTextStorage(storage)
        
        scrollView.documentView = textView
        
        self.view = scrollView
    }
    
    override func viewDidAppear() {
        self.view.window?.makeFirstResponder(self.view)
    }
}
