//
//  CompletionRequest.swift
//  EditorCore
//
//  Created by Arthur Guiot on 6/9/22.
//

import Foundation


public struct CompletionRequest: Codable {
    var model: String = "text-babbage-001"
    var prompt: String
    var max_tokens: Int = 64
    var temperature: Double = 0.29
    var top_p: Double = 1
    var presence_penalty: Double = 0
    var frequency_penalty: Double = 0
    var stop = [".", "\n"]
    var user: String
}

public struct EditRequest: Codable {
    var model: String = "text-davinci-edit-001"
    var input: String
    var instruction: String
    var temperature: Double = 0.5
    var top_p: Double = 1
    
    public init(input: String, instruction: String) {
        self.input = input
        self.instruction = instruction
    }
}

public struct CompletionResponse: Codable {
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

public struct EditResponse: Codable {
    var object = "edit"
    
    public struct Choice: Codable {
        public var text: String
        var index: Int
    }
    public var choices: [Choice]
}


extension CompletionProvider {
    // MARK: - Completion Request
    
    func completion(for request: CompletionRequest) async throws -> CompletionResponse {
        let response = try await fetch(for: CompletionResponse.self, at: "completions", with: request, using: "POST")
        return response
    }
    
    public func edit(for request: EditRequest) async throws -> EditResponse {
        let response = try await fetch(for: EditResponse.self, at: "edits", with: request, using: "POST")
        return response
    }
}
