//
//  EditModification.swift
//  Elva
//
//  Created by Arthur Guiot on 6/23/22.
//

import Foundation
import EditorCore

class EditionController: ObservableObject {
    @Published var modification: String? = nil
    
    func edit(text: String, with instruction: String) async throws {
        let request = EditRequest(input: text, instruction: instruction)
        let edit = try await CompletionProvider.shared.edit(for: request)
        self.modification = edit.choices.first?.text
    }
}
