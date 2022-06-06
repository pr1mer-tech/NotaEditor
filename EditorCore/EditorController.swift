//
//  EditorController.swift
//  Elva
//
//  Created by Arthur Guiot on 6/1/22.
//

import SwiftUI
import STTextView

public class EditorController: NSViewController, STTextViewDelegate {
    public var textView = EditorCore()
    let storage = Storage()
    
    public override func loadView() {
        let theme = Theme.default
        storage.theme = theme
        
        let paragraph = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraph.lineHeightMultiple = 1.1
        paragraph.defaultTabInterval = 28

        textView.defaultParagraphStyle = paragraph
        textView.font = theme.body.attributes[.font] as? UniversalFont
        textView.textColor = .textColor
        textView.storage = storage
        textView.widthTracksTextView = true
        textView.highlightSelectedLine = true
        textView.textFinder.isIncrementalSearchingEnabled = true
        textView.textFinder.incrementalSearchingShouldDimContentView = true
        
        // Storage
        textView.textContentStorage.automaticallySynchronizesToBackingStore = true
        textView.delegate = self

        let scrollView = NSScrollView()
        scrollView.documentView = textView

        // Line numbers
        scrollView.verticalRulerView = STLineNumberRulerView(textView: textView, scrollView: scrollView)
        scrollView.rulersVisible = true
        
        self.view = scrollView
    }
    
    public override func viewDidAppear() {
        self.view.window?.makeFirstResponder(self.view)
    }
}
