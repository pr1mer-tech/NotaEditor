//
//  CompletionRequest.swift
//  EditorCore
//
//  Created by Arthur Guiot on 6/9/22.
//

import Foundation

extension CompletionProvider {
    // MARK: - Completion Request
    
    struct CompletionRequest: Codable {
        var model: String = "text-curie-001"
        var prompt: String
        var max_tokens: Int = 64
        var temperature: Double = 0.29
        var top_p: Double = 1
        var presence_penalty: Double = 0
        var frequency_penalty: Double = 0
        var stop = [".", "\n"]
        var user: String
    }
    
    struct CompletionResponse: Codable {
        var id: String
        var object = "text_completion"
        var model: String
        
        struct Choice: Codable {
            var text: String
            var index: Int
            var finish_reason: String
        }
        var choices: [Choice]
    }
    
    func completion(for request: CompletionRequest) async throws -> CompletionResponse {
        let response = try await fetch(for: CompletionResponse.self, at: "completions", with: request, using: "POST")
        return response
    }
}
