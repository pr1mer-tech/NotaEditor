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
//        let lineAnnotation1 = STLineAnnotation(
//            location: textView.textLayoutManager.location(textView.textLayoutManager.documentRange.location, offsetBy: 0)!
//        )
//        textView.addAnnotation(lineAnnotation1)
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
    
    public func textView(_ textView: STTextView, didChangeTextIn affectedCharRange: NSTextRange, replacementString: String) {
        if replacementString == "z" {
            let attributed = NSMutableAttributedString(string: "Hello World! This is a completion, totally not powered by AI.", attributes: [
                .foregroundColor: UniversalColor.lightGray
            ])
            textView.insertText(attributed)
        }
    }
    
    public func textView(_ textView: STTextView, viewForLineAnnotation lineAnnotation: STLineAnnotation, textLineFragment: NSTextLineFragment) -> NSView? {
            
            let decorationView = STAnnotationLabelView(
                annotation: lineAnnotation,
                label: { Label("Hello World", systemImage: "cross") }
            )

            // Position
            
            let segmentFrame = textView.textLayoutManager.textSelectionSegmentFrame(at: lineAnnotation.location, type: .standard)!
            let annotationHeight = min(textLineFragment.typographicBounds.height, textView.font?.boundingRectForFont.height ?? 24)

            decorationView.frame = CGRect(
                x: segmentFrame.origin.x,
                y: segmentFrame.origin.y + (segmentFrame.height - annotationHeight),
                width: textView.bounds.width - segmentFrame.maxX,
                height: annotationHeight
            )
            return decorationView
    }
}
