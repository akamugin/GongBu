//
//  GenerateContentRequest.swift
//  GongBu
//
//  Created by Stella Lee on 10/5/24.
//

import Foundation

// MARK: - GenerateContentRequest

/// Represents a request to generate content using the generative model.
struct GenerateContentRequest: Codable {
    let contents: [ContentPartWrapper]
    
    init(contents: [ContentPart]) {
        self.contents = contents.map { ContentPartWrapper(part: $0) }
    }
    
    struct ContentPartWrapper: Codable {
        let parts: [Part]
        
        init(part: ContentPart) {
            if let text = part.text {
                self.parts = [Part(text: text)]
            } else if let fileData = part.fileData {
                self.parts = [Part(fileData: fileData)]
            } else {
                self.parts = []
            }
        }
        
        struct Part: Codable {
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
    }
}
