//
//  HandwritingView.swift
//  GongBu
//
//  Created by Stella Lee on 10/5/24.
//

import SwiftUI
import FirebaseVertexAI

struct HandwritingView: View {
    @Environment(\.dismiss) var dismiss
    let word: WordPair
    @State private var drawingImage: UIImage?
    @State private var resultText: String = ""
    @State private var isCorrect: Bool?
    @State private var isLoading: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    dismiss()
                }) {
//                    HStack(spacing: 8) {
//                        Image(systemName: "chevron.left.circle.fill")
//                            .font(.system(size: 24))
//                        Text("Back")
//                            .font(.system(size: 18, weight: .medium, design: .rounded))
//                    }
//                    .foregroundColor(.white)
//                    .padding(12)
//                    .background(
//                        Capsule()
//                            .fill(Color(hex: "FF69B4").opacity(0.8))
//                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
//                    )
                }
                Spacer()
            }
            .padding(.horizontal)
            
            Text("Write: \(word.english)")
                .font(.headline)
                .padding()
            
            CanvasView(drawing: $drawingImage)
                .frame(width: 300, height: 300)
                .border(Color.gray, width: 1)
                .padding()
            
            HStack {
                Button(action: {
                    // Reset the drawing and results
                    drawingImage = nil
                    resultText = ""
                    isCorrect = nil
                }) {
                    Text("Clear")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    // Submit the drawing for recognition
                    recognizeHandwriting()
                }) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(8)
                    } else {
                        Text("Submit")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .disabled(isLoading || drawingImage == nil)
            }
            .padding([.leading, .trailing])
            
            // Display the recognized text and correctness
            if !resultText.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Recognized:")
                        .font(.subheadline)
                        .bold()
                    
                    Text(resultText)
                        .font(.body)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(8)
                    
                    if let correct = isCorrect {
                        Text(correct ? "Correct!" : "Incorrect.")
                            .foregroundColor(correct ? .green : .red)
                            .font(.headline)
                    }
                }
                .padding()
            }
            
            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK")))
        }
    }

    /// Recognizes handwriting by sending the drawing image to the Firebase Vertex AI API.
    func recognizeHandwriting() {
        guard let image = drawingImage else { return }
        
        // Set loading state
        isLoading = true
        
        Task {
            let prompt = "Write in JSON output key called \"korean\" that contains the korean letters seen."
            let recognizedText = await GoogleCloudAPI.recognizeHandwriting(image: image, prompt: prompt)
            
            DispatchQueue.main.async {
                self.isLoading = false
                if !recognizedText.isEmpty {
                    self.resultText = recognizedText
                    // Compare the recognized text with the correct Korean word (case-insensitive)
                    self.isCorrect = (recognizedText.lowercased() == word.korean.lowercased())
                } else {
                    self.resultText = "No Korean text detected."
                    self.isCorrect = false
                }
            }
        }
    }
}

struct HandwritingView_Previews: PreviewProvider {
    static var previews: some View {
        // Corrected parameter order: 'korean' precedes 'english'
        HandwritingView(word: WordPair(korean: "자동차", english: "Car"))
    }
}
