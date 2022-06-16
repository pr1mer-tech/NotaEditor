//
//  Stats.swift
//  Elva
//
//  Created by Arthur Guiot on 6/13/22.
//

import Foundation
import SwiftUI
import GPT_Tokenizer

class DocumentStateManager: ObservableObject {
    @Published var networkActivity = false
    
    @Published var tokens: Int = 0
    @Published var paragraph: Int = 0
    @Published var sentences: Int = 0
    func process(content: String) {
        let tokenizer = GPT_Tokenizer()
        self.tokens = tokenizer.encode(text: content).count
        
        self.paragraph = content.numberOfParagraphs
        self.sentences = content.numberOfSentences
    }
}
