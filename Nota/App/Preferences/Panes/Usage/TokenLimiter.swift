//
//  UsageTokenMultiplicator.swift
//  Nota
//
//  Created by Arthur Guiot on 6/27/22.
//

import Foundation
import EditorCore
class TokenLimiter: ObservableObject {
    static let shared = TokenLimiter()
    
    let maxUsageToken = 1_250_000 // Base token
    let throttleUsage = 150_000 // Will be using small model
    
    
    @Published var userBought = 0 // Number of tokens bought by the user
    
    
    var usableTokens: Int {
        return maxUsageToken + userBought
    }
    
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
    
    func expectedLimitReach(lastReset: Date, currentUsage: Int) -> Date? {
        guard currentUsage > 1000 else { return nil }
        // Check if last reset is at least 1 day ago
        let lastResetInterval = lastReset.timeIntervalSinceNow
        guard lastResetInterval < -24 * 60 * 60 else { return nil }
        guard lastResetInterval < -30 * 24 * 60 * 60 else { return nil }

        // Calculate expected date where `usableTokens` will be reached given current usage
        let currentPace = Double(currentUsage) / lastResetInterval
        let expected = currentPace * Double(usableTokens - throttleUsage - currentUsage) + lastResetInterval
        let date = Date(timeInterval: expected, since: Date())
        // If date is further than 1 month after last reset, return nil
        guard date.timeIntervalSinceNow < 30 * 24 * 60 * 60 else { return nil }
        return date
    }
}
