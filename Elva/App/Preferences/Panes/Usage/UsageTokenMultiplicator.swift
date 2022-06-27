//
//  UsageTokenMultiplicator.swift
//  Elva
//
//  Created by Arthur Guiot on 6/27/22.
//

import Foundation
import EditorCore
class UsageTokenMultiplicator {
    static let shared = UsageTokenMultiplicator()
    
    let maxUsageToken = 1_250_000 // Base token
    
    func usage(for tokens: Int, using model: GPTModel) -> Int {
        switch model {
        case .davinci:
            return tokens * 75
        case .curie:
            return Int(Float(tokens) * 7.5)
        case .babbage:
            return Int(Float(tokens) * 1.5)
        case .ada:
            return tokens
        case .davinciEdit:
            return tokens * 0 // Edits is currently free to use
        }
    }
}
