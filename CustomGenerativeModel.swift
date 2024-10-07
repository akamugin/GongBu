//
//  CustomGenerativeModel.swift
//  GongBu
//
//  Created by Stella Lee on 10/5/24.
//

import Foundation
import GoogleGenerativeAI

/// Represents a custom generative model with necessary configurations.
struct CustomGenerativeModel {
    let name: String
    let apiKey: String
    let generationConfig: GenerationConfig
    
    init(name: String, apiKey: String, generationConfig: GenerationConfig) {
        self.name = name
        self.apiKey = apiKey
        self.generationConfig = generationConfig
    }
    
    /// Generates content based on the provided request.
    /// - Parameter request: The content generation request.
    /// - Returns: A response containing the generated content.
    func generateContent(_ request: GenerateContentRequest) async throws -> GenerateContentResponse {
        // Convert GenerateContentRequest to JSON data
        let jsonData = try JSONEncoder().encode(request)
        
        // Create the request URL using self.name and self.apiKey
        let endpoint = "https://generativelanguage.googleapis.com/v1beta/models/\(self.name):generateContent"
        
        guard let url = URL(string: "\(endpoint)?key=\(self.apiKey)") else {
            throw URLError(.badURL)
        }
        
        // Prepare the URLRequest
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = jsonData
        
        // Perform the network request
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        // Check for HTTP response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.init(rawValue: httpResponse.statusCode))
        }
        
        // Decode the response
        let generateResponse = try JSONDecoder().decode(GenerateContentResponse.self, from: data)
        return generateResponse
    }
}
