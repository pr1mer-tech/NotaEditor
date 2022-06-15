//
//  Stats.swift
//  Elva
//
//  Created by Arthur Guiot on 6/13/22.
//

import Foundation
import SwiftUI
import GPT_Tokenizer

class DocumentManager: ObservableObject {
    @Published var networkActivity = false
    
    @Published var wordCount: Int = 0
    
    var tokens: Int = 0
    
    func process(content: String) {
        self.wordCount = content.numberOfWords
    }
}
