//
//  RequestBuilder.swift
//  EditorCore
//
//  Created by Arthur Guiot on 6/14/22.
//

import Foundation

extension CompletionRequest {
    static func buildRequest(for sentences: [String], stoppingAt index: Int) -> CompletionRequest? {
        // Build string with last 3 sentences (if they exist)
        var prompt = ""
        for i in 0..<3 {
            if index - i >= 0 {
                let sentence = sentences[index - i]
                guard i != 0 || sentence.count > 5 else { return nil }
                guard sentence.count < 200 else {
                    // Truncate if too long
                    prompt =  "..." + sentence.suffix(200) + prompt
                    break
                }
                prompt = sentence + prompt
            }
        }
        prompt = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard prompt.count > 5 else { return nil }
        if prompt.count > 3500 {
            // Truncate if too long
            prompt = "..." + prompt.suffix(3500)
        }

        // Build request
        let deviceID = CompletionProvider.hardwareUUID() ?? "unknown"
        let request = CompletionRequest(prompt: prompt, user: deviceID)
        return request
    }
}
