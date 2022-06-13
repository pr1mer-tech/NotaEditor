//
//  EditorView.swift
//  Elva
//
//  Created by Arthur Guiot on 6/1/22.
//

import SwiftUI
import EditorCore

struct EditorView: NSViewControllerRepresentable {
    @Binding var text: String
    @EnvironmentObject var stats: Stats
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, EditorStatisticsDelegate {
        func startedCompletionActivity(with request: CompletionRequest) {
            self.parent.stats.networkActivity = true
        }
        
        func finishedCompletionActivity(with response: CompletionResponse) {
            self.parent.stats.networkActivity = false
        }
        
        private var parent: EditorView
        var shouldUpdateText = true
        
        init(_ parent: EditorView) {
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
            
            self.parent.stats.wordCount = self.parent.text.numberOfWords
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
            self.stats.wordCount = self.text.numberOfWords
            context.coordinator.shouldUpdateText = true
        }
    }
}
