//
//  GoogleCloudAPI.swift
//  GongBu
//
//  Created by Stella Lee on 10/5/24.
//

import Foundation
import UIKit
import FirebaseVertexAI

// Struct to match the JSON response from the API
struct RecognizedText: Decodable {
    let korean: String
}

struct GoogleCloudAPI {
    /// Asynchronously recognizes handwriting by sending the drawing image to the Firebase Vertex AI API.
    /// - Parameters:
    ///   - image: The UIImage to analyze.
    ///   - prompt: The text prompt to include with the image.
    /// - Returns: The extracted Korean text or an empty string on failure.
    static func recognizeHandwriting(image: UIImage, prompt: String = "Write in JSON output key called \"korean\" that contains the korean letters seen.") async -> String {
        do {
            // Initialize the Vertex AI service
            let vertex = VertexAI.vertexAI()
            
            // Initialize the generative model with a model that supports your use case
            let model = vertex.generativeModel(modelName: "gemini-1.5-flash")
            
            // Generate content asynchronously
            let response = try await model.generateContent(image, prompt)
            
            // Extract the text from the response
            if let text = response.text {
                print("Extracted Korean Text: \(text)")
                
                // Use regex to find the JSON object within the text
                if let jsonObject = extractJSON(from: text) {
                    // Decode the JSON string to extract "korean"
                    if let data = jsonObject.data(using: .utf8) {
                        let decoder = JSONDecoder()
                        let recognizedText = try decoder.decode(RecognizedText.self, from: data)
                        print("Parsed Korean Text: \(recognizedText.korean)")
                        return recognizedText.korean
                    } else {
                        print("Failed to convert extracted JSON string to Data.")
                        return ""
                    }
                } else {
                    print("No valid JSON object found in the response.")
                    return ""
                }
            } else {
                print("No text extracted from the response.")
                return ""
            }
        } catch {
            print("Error during handwriting recognition: \(error.localizedDescription)")
            return ""
        }
    }
    
    /// Asynchronously recognizes speech by sending the audio data to the Firebase Vertex AI API.
    /// - Parameters:
    ///   - audioURL: The URL of the audio file to analyze.
    ///   - prompt: The text prompt to include with the audio.
    /// - Returns: The extracted Korean text or an empty string on failure.
    static func recognizeSpeech(audioURL: URL, prompt: String = "Write in JSON output key called \"korean\" that contains the korean letters spoken.") async -> String {
        do {
            // Initialize the Vertex AI service
            let vertex = VertexAI.vertexAI()
            
            // Initialize the generative model with a model that supports your use case
            let model = vertex.generativeModel(modelName: "gemini-1.5-flash")
            
            // Read audio data
            let audioData = try Data(contentsOf: audioURL)
            
            // Create ModelContent with audio data
            let audioContent = ModelContent.Part.data(mimetype: "audio/wav", audioData)
            
            // Generate content asynchronously
            let response = try await model.generateContent(audioContent, prompt)
            
            // Extract the text from the response
            if let text = response.text {
                print("Extracted Korean Text: \(text)")
                
                // Use regex to find the JSON object within the text
                if let jsonObject = extractJSON(from: text) {
                    // Decode the JSON string to extract "korean"
                    if let data = jsonObject.data(using: .utf8) {
                        let decoder = JSONDecoder()
                        let recognizedText = try decoder.decode(RecognizedText.self, from: data)
                        print("Parsed Korean Text: \(recognizedText.korean)")
                        return recognizedText.korean
                    } else {
                        print("Failed to convert extracted JSON string to Data.")
                        return ""
                    }
                } else {
                    print("No valid JSON object found in the response.")
                    return ""
                }
            } else {
                print("No text extracted from the response.")
                return ""
            }
        } catch {
            print("Error during speech recognition: \(error.localizedDescription)")
            return ""
        }
    }
    
    /// Extracts the first JSON object found within a given text using regular expressions.
    /// - Parameter text: The input text containing a JSON object.
    /// - Returns: The JSON string if found, otherwise nil.
    private static func extractJSON(from text: String) -> String? {
        // Define the regex pattern to match JSON objects
        let pattern = "\\{[^\\{\\}]*\\}"
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let nsText = text as NSString
            let range = NSRange(location: 0, length: nsText.length)
            
            if let match = regex.firstMatch(in: text, options: [], range: range) {
                let jsonString = nsText.substring(with: match.range)
                return jsonString
            } else {
                return nil
            }
        } catch {
            print("Regex error: \(error.localizedDescription)")
            return nil
        }
    }
}
