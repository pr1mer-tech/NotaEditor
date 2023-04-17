//
//  CompletionProvider.swift
//  EditorCore
//
//  Created by Arthur Guiot on 6/8/22.
//

import Foundation

public class CompletionProvider {
    public static let shared = CompletionProvider()
    
    let baseURL = "https://Nota-gpt.pr1mer.tech"
    
    // MARK: - Make a request
    func fetch<T, E>(for decodingType: T.Type, at path: String, with body: E? = nil, using method: String = "GET") async throws -> T where T: Decodable, E: Encodable {
        let url = URL(string: "\(baseURL)/\(path)")!
        var request = URLRequest(url: url)
        if let body = body {
            let requestBody = try JSONEncoder().encode(body)
            request.httpBody = requestBody
            // Only for POST
            request.httpMethod = method
        }
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(decodingType, from: data)
        return decoded
    }

    
    struct DefaultBody: Codable {}
    func get<T>(for decodingType: T.Type, at path: String) async throws -> T where T: Decodable {
        let url = URL(string: "\(baseURL)/\(path)")!
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(decodingType, from: data)
        return decoded
    }
    
    // MARK: - Quick Methods

    // Models
    public struct ModelsResponse: Codable {
        var object = "list"

        public struct Model: Codable {
            let id: String
            var object = "model"
        }
        let data: [Model]
    }
    public func getModels() async throws -> [ModelsResponse.Model] {
        let response = try await get(for: ModelsResponse.self, at: "models")
        return response.data
    }
    
    // MARK: - Security
    static public func hardwareUUID() -> String? {
        let matchingDict = IOServiceMatching("IOPlatformExpertDevice")
        let platformExpert = IOServiceGetMatchingService(kIOMainPortDefault, matchingDict)
        defer{ IOObjectRelease(platformExpert) }

        guard platformExpert != 0 else { return nil }
        return IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformUUIDKey as CFString, kCFAllocatorDefault, 0).takeRetainedValue() as? String
    }
}
