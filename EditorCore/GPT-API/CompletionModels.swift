//
//  CompletionModels.swift
//  EditorCore
//
//  Created by Arthur Guiot on 6/27/22.
//

import Foundation


public enum GPTModel: String, Codable {
    // Normal
    case davinci = "text-davinci-002"
    case curie   = "text-curie-001"
    case babbage = "text-babbage-001"
    case ada     = "text-ada-001"
    // Edits
    case davinciEdit = "text-davinci-edit-001"
}

// MARK: - Request
public struct CompletionRequest: Codable {
    var model: GPTModel = .babbage
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
    var model: GPTModel = .davinciEdit
    var input: String
    var instruction: String
    var temperature: Double = 0.5
    var top_p: Double = 1
    
    public init(input: String, instruction: String) {
        self.input = input
        self.instruction = instruction
    }
}

// MARK: Response

public struct Usage: Codable {
    var prompt_tokens: Int
    var completion_tokens: Int?
    public var total_tokens: Int
}

public struct CompletionResponse: Codable {
    var id: String
    var object = "text_completion"
    public var model: GPTModel
    
    public struct Choice: Codable {
        public var text: String
        var index: Int
        var finish_reason: String
    }
    public var choices: [Choice]
    
    public var usage: Usage
}

public struct EditResponse: Codable {
    public var model: GPTModel = GPTModel.davinciEdit
    var object = "edit"
    
    public struct Choice: Codable {
        public var text: String
        var index: Int
    }
    public var choices: [Choice]
    
    public var usage: Usage
    
    enum CodingKeys: String, CodingKey {
        case object, choices, usage
    }
}
