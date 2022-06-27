//
//  CompletionRequest.swift
//  EditorCore
//
//  Created by Arthur Guiot on 6/9/22.
//

import Foundation


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
