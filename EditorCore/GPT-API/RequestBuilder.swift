//
//  RequestBuilder.swift
//  EditorCore
//
//  Created by Arthur Guiot on 6/14/22.
//

import Foundation
import GPT_Tokenizer

extension CompletionRequest {
    
    static let tokenizer = GPT_Tokenizer()
    
    static func buildRequest(for sentences: [String], stoppingAt index: Int) -> CompletionRequest? {
        // Build string with last 3 sentences (if they exist)
        var prompt = ""
        var tokens = 0

        // Iterate backwards
        for i in stride(from: index, to: -1, by: -1) { // Stride doesn't include end value. So we're stopping to 0
            if let sentence = sentences[i] as String? {
                let tokenized = CompletionRequest.tokenizer.encode(text: sentence)
                tokens += tokenized.count
                if tokens >= 100 {
                    // We have enough tokens, we truncate the sentence
                    prompt = "[...] " + sentence.suffix(200) + prompt
                    break
                }
                prompt = sentence + prompt
            }
        }

        prompt = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard prompt.count > 5 else { return nil }

        // // Make sure prompt doesn't end with a period
        // guard prompt.last != "." else { return nil }

        // Build request
        let deviceID = CompletionProvider.hardwareUUID() ?? "unknown"
        let request = CompletionRequest(instruction: prompt, user: deviceID, model: .babbage, max_tokens: 64)
        return request
    }
}
