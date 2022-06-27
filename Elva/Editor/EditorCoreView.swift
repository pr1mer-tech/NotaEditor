//
//  EditorView.swift
//  Elva
//
//  Created by Arthur Guiot on 6/1/22.
//

import SwiftUI
import EditorCore
import GPT_Tokenizer

struct EditorCoreView: NSViewControllerRepresentable {
    @EnvironmentObject var document: MarkdownDocument
    
    @Preference(\.completionUsage) var tokenUsage
    @Preference(\.completionLastReset) var lastReset
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, EditorCoreDelegate {
        func selecting(text: String?) {
            self.parent.document.selecting = text
            self.parent.document.selectionReplacement = nil // Making sure we invalidate any change when text selection changes.
        }
        
        func startedCompletionActivity(with request: CompletionRequest) {
            self.parent.document.networkActivity = true
        }
        
        func finishedCompletionActivity(with response: CompletionResponse? = nil) {
            self.parent.document.networkActivity = false
            if let response = response {
                // If last reset is older than 1 month, we reset the usage
                if self.parent.lastReset.timeIntervalSinceNow < -30 * 24 * 60 * 60 {
                    self.parent.tokenUsage = 0
                    self.parent.lastReset = .now
                }
                self.parent.tokenUsage += TokenLimiter.shared.usage(for: response.usage.total_tokens, using: response.model)
            }
        }
        
        private var parent: EditorCoreView
        var shouldUpdateText = true
        
        init(_ parent: EditorCoreView) {
            self.parent = parent
        }
        
        func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
            guard shouldUpdateText else {
                return
            }
            let edited = textStorage.attributedSubstring(from: editedRange).string
            let insertIndex = parent.document.content.utf16.index(parent.document.content.utf16.startIndex, offsetBy: editedRange.lowerBound)
            
            func numberOfCharactersToDelete() -> Int {
                editedRange.length - delta
            }
            
            let endIndex = parent.document.content.utf16.index(insertIndex, offsetBy: numberOfCharactersToDelete())
            self.parent.document.content.replaceSubrange(insertIndex..<endIndex, with: edited)
        }
    }

    func makeNSViewController(context: Context) -> EditorController {
        let vc = EditorController()
        vc.storage.delegate = context.coordinator
        return vc
    }
    
    func updateNSViewController(_ nsViewController: EditorController, context: Context) {
        if document.content != nsViewController.textView.string {
            context.coordinator.shouldUpdateText = false
            nsViewController.textView.string = document.content
            context.coordinator.shouldUpdateText = true
        }
        if document.selectionReplacement != nil {
            nsViewController.replaceSelectedContent(with: document.selectionReplacement!)
            document.selectionReplacement = nil // Replacment once
        }
    }
}
