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
    
    let completion = CompletionProvider()
    var lastEdit = Date()

    var gptEdited = false
    
    public func textView(_ textView: STTextView, didChangeTextIn affectedCharRange: NSTextRange, replacementString: String) {
        lastEdit = Date()
        
        let content = textView.attributedString()
        if let gptRange = content.GPTCompletionRange {
            guard gptEdited == false else {
                gptEdited.toggle()
                return
            }
            // If the replacement string is the same as the beginning of the completion string, remove the duplicate beginning
            if replacementString.count > 0 && replacementString == content.string[gptRange.location..<gptRange.location + replacementString.count] {
                guard let replacementRange = textView.nsTextRange(from: NSRange(location: gptRange.location, length: replacementString.count)) else { return }
                textView.replaceCharacters(in: replacementRange, with: "")
            } else if replacementString.count > 0 {
                guard let replacementRange = textView.nsTextRange(from: NSRange(location: gptRange.location, length: gptRange.length)) else { return }
                textView.replaceCharacters(in: replacementRange, with: "") // Removing completion
            }
            
            return
        }
        
        // Check in 0.5 seconds if the user has stopped typing
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.lastEdit.timeIntervalSinceNow < -1 {
                // User has stopped typing
                Task {
                    do {
                        // Get sentence at cursor
                        let range = textView.nsRange(from: affectedCharRange)
                        let cursor = range.location
                        guard let attributedString = textView.textContentStorage.attributedString else { return }
                        let string = attributedString.string
                        let sentence = string.sentences.first(where: { (sentence) -> Bool in
                            let range = (string as NSString).range(of: sentence)
                            if range.location < cursor && range.location + range.length > cursor {
                                return true
                            }
                            return false
                        })
                        
                        guard sentence?.count ?? 0 > 5 else { return }
                        
                        let prompt = sentence!.trimmingCharacters(in: .whitespacesAndNewlines)
                        let request = CompletionProvider.CompletionRequest(prompt: prompt, user: UUID().uuidString)
                        let result = try await self.completion.completion(for: request)
                        
                        guard let choice = result.choices.first else { return }
                        var completion = choice.text
                        // If sentence and completion both ends and start with a space, remove it
                        if sentence!.last == " " && completion.first == " " {
                            completion = String(completion.dropFirst())
                        }
                        let attributed = NSMutableAttributedString(string: completion, attributes: [
                            .foregroundColor: UniversalColor.lightGray,
                            .gptCompletion: true
                        ])
                        self.gptEdited = true
                        textView.insertText(attributed)
                        let cursorLocation = textView.textContentStorage.location(affectedCharRange.endLocation, offsetBy: 1) ?? affectedCharRange.endLocation
                        let cursorRange = NSTextRange(location: cursorLocation)
                        textView.setSelectedRange(cursorRange, updateLayout: true)
                    } catch {
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
}
