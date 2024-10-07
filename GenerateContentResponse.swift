//
//  GenerateContentResponse.swift
//  GongBu
//
//  Created by Stella Lee on 10/5/24.
//

import Foundation

// MARK: - GenerateContentResponse

/// Represents the response from the generateContent API.
struct GenerateContentResponse: Codable {
    let candidates: [Candidate]
    
    struct Candidate: Codable {
        let content: CandidateContent
    }
    
    struct CandidateContent: Codable {
        let parts: [CandidatePart]
        
        struct CandidatePart: Codable {
            let text: String?
            let mimeType: String?
            let fileURI: String?
            
            enum CodingKeys: String, CodingKey {
                case text
                case mimeType = "mime_type"
                case fileURI = "file_uri"
            }
        }
    }
}
