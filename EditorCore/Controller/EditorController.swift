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
    public let storage = Storage()
    
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
        
        // Storage
        textView.textContentStorage.automaticallySynchronizesToBackingStore = true
        textView.delegate = self

        let scrollView = NSScrollView()
        scrollView.documentView = textView

        // Line numbers
        scrollView.verticalRulerView = STLineNumberRulerView(textView: textView, scrollView: scrollView)
        scrollView.rulersVisible = false
        
        self.view = scrollView
    }
    
    public override func viewDidAppear() {
        self.view.window?.makeFirstResponder(self.view)
    }
    
    let completion = CompletionProvider()
    var lastEdit = Date()
    
    public func textView(_ textView: STTextView, didChangeTextIn affectedCharRange: NSTextRange, replacementString: String) {
        lastEdit = Date()
        self.textView.networkTask?.cancel() // Making sure there is no duplicate request
        
        guard (storage.delegate as? EditorStorageDelegate)?.shouldUpdateText ?? true else { return }
        
        let content = textView.attributedString()
        if let gptRange = content.GPTCompletionRange {
            return processInputWithCompletion(textView, content: content, didChangeTextIn: affectedCharRange, withCompletionIn: gptRange, replacementString: replacementString)
        }
        
        // Check in 0.5 seconds if the user has stopped typing
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.lastEdit.timeIntervalSinceNow < -1 {
                // User has stopped typing
                self.textView.networkTask = Task {
                    do {
                        try await self.completeSentence(textView, didChangeTextIn: affectedCharRange, replacementString: replacementString)
                    } catch {
                        let delegate = textView.textContentStorage.textStorage?.delegate as? EditorStorageDelegate
                        delegate?.finishedCompletionActivity(with: nil)
                        print(error)
                    }
                }
            }
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
    
    public func textViewDidChangeSelection(_ notification: Notification) {
        let selected = textView.selectedRange()
        let attributed = storage.attributedSubstring(from: selected)
        guard let storageDelegate = storage.delegate as? EditorStorageDelegate else { return }
        storageDelegate.selecting(text: selected.length > 0 ? attributed.string : nil)
    }
}
