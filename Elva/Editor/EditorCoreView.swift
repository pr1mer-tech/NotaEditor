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
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, EditorStorageDelegate {
        func startedCompletionActivity(with request: CompletionRequest) {
            self.parent.document.networkActivity = true
        }
        
        func finishedCompletionActivity(with response: CompletionResponse) {
            self.parent.document.networkActivity = false
        }
        
        private var parent: EditorCoreView
        var shouldUpdateText = true
        
        init(_ parent: EditorCoreView) {
            self.parent = parent
        }
        
        func textStorage(_ textStorage: NSTextStorage, willProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
            guard let vc = self.parent.document.contentViewController else { return }
            self.parent.document.objectDidBeginEditing(vc)
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
            guard let vc = self.parent.document.contentViewController else { return }
            self.parent.document.objectDidEndEditing(vc)
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
    }
}
