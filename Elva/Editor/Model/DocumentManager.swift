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
    
    @Published var tokens: Int = 0
    
    func process(content: String) {
        let tokenizer = GPT_Tokenizer()
        self.tokens = tokenizer.encode(text: content).count
    }
}
