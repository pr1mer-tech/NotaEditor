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
    
    @Binding var text: String
    
    @EnvironmentObject var manager: DocumentStateManager
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, EditorStorageDelegate {
        func startedCompletionActivity(with request: CompletionRequest) {
            self.parent.manager.networkActivity = true
        }
        
        func finishedCompletionActivity(with response: CompletionResponse) {
            self.parent.manager.networkActivity = false
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
            let insertIndex = parent.text.utf16.index(parent.text.utf16.startIndex, offsetBy: editedRange.lowerBound)
            
            func numberOfCharactersToDelete() -> Int {
                editedRange.length - delta
            }
            
            let endIndex = parent.text.utf16.index(insertIndex, offsetBy: numberOfCharactersToDelete())
            self.parent.text.replaceSubrange(insertIndex..<endIndex, with: edited)
        }
    }

    func makeNSViewController(context: Context) -> EditorController {
        let vc = EditorController()
        vc.storage.delegate = context.coordinator
        return vc
    }
    
    func updateNSViewController(_ nsViewController: EditorController, context: Context) {
        if text != nsViewController.textView.string {
            context.coordinator.shouldUpdateText = false
            nsViewController.textView.string = text
            context.coordinator.shouldUpdateText = true
        }
    }
}