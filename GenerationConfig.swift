//
//  GenerationConfig.swift
//  GongBu
//
//  Created by Stella Lee on 10/5/24.
//

import Foundation

// MARK: - GenerationConfig

/// Represents the configuration for content generation.
struct GenerationConfig: Codable {
    let responseMIMEType: String
    let responseSchema: Schema?
    
    init(responseMIMEType: String, responseSchema: Schema? = nil) {
        self.responseMIMEType = responseMIMEType
        self.responseSchema = responseSchema
    }
}

// MARK: - Schema

/// Represents a schema for controlled generation.
class Schema: Codable {
    let type: SchemaType
    let description: String?
    let items: Schema?
    let properties: [String: Schema]?
    let requiredProperties: [String]?
    
    init(type: SchemaType, description: String? = nil, items: Schema? = nil, properties: [String: Schema]? = nil, requiredProperties: [String]? = nil) {
        self.type = type
        self.description = description
        self.items = items
        self.properties = properties
        self.requiredProperties = requiredProperties
    }
    
    // MARK: - CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case type
        case description
        case items
        case properties
        case requiredProperties
    }
}

// MARK: - SchemaType

/// Enum representing different schema types.
enum SchemaType: String, Codable {
    case array
    case object
    case string
    case number
    case boolean
    case null
}
