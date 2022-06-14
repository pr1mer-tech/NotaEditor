//
//  CompletionHandling.swift
//  EditorCore
//
//  Created by Arthur Guiot on 6/14/22.
//

import Foundation
import STTextView
import AppKit

extension EditorController {
    
    func completeSentence(_ textView: STTextView, didChangeTextIn affectedCharRange: NSTextRange, replacementString: String) async throws {
        // Get sentence at cursor
        let range = textView.nsRange(from: affectedCharRange)
        let cursor = range.location
        guard let attributedString = textView.textContentStorage.attributedString else { return }
        let string = attributedString.string
        
        let sentences = string.sentences
        
        let sentenceIndex = sentences.firstIndex(where: { (sentence) -> Bool in
            let range = (string as NSString).range(of: sentence)
            if range.location < cursor && range.location + range.length > cursor {
                return true
            }
            return false
        }) ?? sentences.count - 1
        
        
        
        guard let request = CompletionRequest.buildRequest(for: sentences, stoppingAt: sentenceIndex) else { return }
        
        let delegate = textView.textContentStorage.textStorage?.delegate as? EditorStatisticsDelegate
        
        delegate?.startedCompletionActivity(with: request)
        
        let result = try await self.completion.completion(for: request)
        
        delegate?.finishedCompletionActivity(with: result)
        
        guard let choice = result.choices.first else { return }
        var completion = choice.text
        // If sentence and completion both ends and start with a space, remove it
        if sentences[sentenceIndex].last == " " && completion.first == " " {
            completion = String(completion.dropFirst())
        }
        let attributed = NSMutableAttributedString(string: completion, attributes: [
            .foregroundColor: UniversalColor.lightGray,
            .gptCompletion: true
        ])
        textView.textContentStorage.textStorage?
            .insert(attributed, at: cursor + replacementString.count)
        

        let cursorLocation = textView.textContentStorage.location(affectedCharRange.endLocation, offsetBy: replacementString.count) ?? affectedCharRange.endLocation
        let cursorRange = NSTextRange(location: cursorLocation)
        textView.setSelectedRange(cursorRange, updateLayout: true)
    }
    
    func processInputWithCompletion(_ textView: STTextView, content: NSAttributedString, didChangeTextIn affectedCharRange: NSTextRange, withCompletionIn gptRange: NSRange, replacementString: String) {
        guard replacementString != "\t" else {
            return validateCompletion(textView, didChangeTextIn: affectedCharRange, replacementString: replacementString, withCompletionIn: gptRange)
        }
        // If the replacement string is the same as the beginning of the completion string, remove the duplicate beginning
        if replacementString.count > 0 && replacementString == content.string[gptRange.location..<gptRange.location + replacementString.count] {
            let replacementRange = NSRange(location: gptRange.location, length: replacementString.count)
            textView.textContentStorage.textStorage?
                .replaceCharacters(in: replacementRange, with: "")
        } else if replacementString.count > 0 {
            let replacementRange = NSRange(location: gptRange.location, length: gptRange.length)
            textView.textContentStorage.textStorage?
                .replaceCharacters(in: replacementRange, with: "") // Removing completion
        }
        
        textView.needsDisplay = true
    }
    
    func validateCompletion(_ textView: STTextView, didChangeTextIn affectedCharRange: NSTextRange, replacementString: String, withCompletionIn gptRange: NSRange) {
        let wholeRange = NSRange(location: 0, length: (storage.string as NSString).length)
        self.storage.removeAttribute(.gptCompletion, range: wholeRange)
        // Remove the key used to complete
        let endLocation = textView.textContentStorage.location(affectedCharRange.endLocation, offsetBy: replacementString.count) ?? affectedCharRange.endLocation
        guard let replacementRange = NSTextRange(location: affectedCharRange.location, end: endLocation) else { return }
        textView.textContentStorage.textStorage?
            .replaceCharacters(in: textView.nsRange(from: replacementRange), with: "")
        // Put cursor at the end
        if let cursorLocation = textView.textContentStorage.location(textView.textLayoutManager.documentRange.location, offsetBy: gptRange.upperBound - replacementString.count) {
            let cursorRange = NSTextRange(location: cursorLocation)
            print(cursorRange)
            textView.setSelectedRange(cursorRange, updateLayout: true)
        }
    }
}
