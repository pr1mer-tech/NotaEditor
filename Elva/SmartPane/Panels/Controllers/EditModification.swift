//
//  EditModification.swift
//  Elva
//
//  Created by Arthur Guiot on 6/23/22.
//

import Foundation
import EditorCore

class EditionController: ObservableObject {
    @Published var modification: EditResponse? = nil
    
    func edit(text: String, with instruction: String) async throws {
        let request = EditRequest(input: text, instruction: instruction)
        let edit = try await CompletionProvider.shared.edit(for: request)
        
        DispatchQueue.main.async {
            self.modification = edit
        }
    }
    
    func write(using instruction: String, max_tokens: Int, stop: CompletionRequest.StopSequence) async throws -> CompletionResponse {
        let deviceID = CompletionProvider.hardwareUUID() ?? "unknown"
        let prompt = "\(instruction)\n"
        let request = CompletionRequest(instruction: prompt, user: deviceID, model: .curie, max_tokens: max_tokens, stop: stop)
        
        let completion = try await CompletionProvider.shared.completion(for: request)
        
        return completion
    }
}
