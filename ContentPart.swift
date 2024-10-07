//
//  ContentPart.swift
//  GongBu
//
//  Created by Stella Lee on 10/5/24.
//

import Foundation

// MARK: - ContentPart

/// Represents a part of the content to be generated, either text or file data.
struct ContentPart: Codable {
    let text: String?
    let fileData: FileData?
    
    init(text: String) {
        self.text = text
        self.fileData = nil
    }
    
    init(fileData: FileData) {
        self.text = nil
        self.fileData = fileData
    }
}

/// Represents file data with MIME type and file URI.
struct FileData: Codable {
    let mimeType: String
    let fileURI: String
    
    enum CodingKeys: String, CodingKey {
        case mimeType = "mime_type"
        case fileURI = "file_uri"
    }
}
