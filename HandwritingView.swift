import SwiftUI
import UIKit

struct HandwritingView: View {
    let word: WordPair
    @Environment(\.presentationMode) var presentationMode
    @State private var drawingImage: UIImage?
    @State private var resultText: String = ""
    @State private var isCorrect: Bool?
    @State private var isLoading: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        VStack {
            Text("Write: \(word.english)")
                .font(.headline)
                .padding()

            CanvasView(drawing: $drawingImage)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.6)
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

    func recognizeHandwriting() {
        guard let image = drawingImage else { return }

        // Convert UIImage to Data (PNG format)
        guard let imageData = image.pngData() else { return }

        // Set up the API call
        guard let apiKey = getGoogleAPIKey() else {
            showAlert(message: "Failed to retrieve API key.")
            return
        }

        let url = URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(apiKey)")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Prepare the request body
        let base64Image = imageData.base64EncodedString()
        let requestBody: [String: Any] = [
            "requests": [
                [
                    "image": ["content": base64Image],
                    "features": [["type": "DOCUMENT_TEXT_DETECTION"]]
                ]
            ]
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            request.httpBody = jsonData

            // Log the request body for debugging purposes
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Request JSON: \(jsonString)")
            }
        } catch {
            showAlert(message: "Failed to serialize request body: \(error.localizedDescription)")
            return
        }

        // Make the API call
        isLoading = true
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }

            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(message: "Error with the API request: \(error.localizedDescription)")
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.showAlert(message: "No data received from the API.")
                }
                return
            }

            // Log the response for debugging purposes
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response JSON: \(responseString)")
            }

            // Decode the response
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let responses = jsonResponse["responses"] as? [[String: Any]],
                   let textAnnotations = responses.first?["textAnnotations"] as? [[String: Any]],
                   let recognizedText = textAnnotations.first?["description"] as? String {
                    DispatchQueue.main.async {
                        self.resultText = recognizedText.trimmingCharacters(in: .whitespacesAndNewlines)
                        self.isCorrect = (self.resultText.lowercased() == word.korean.lowercased())
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showAlert(message: "Unexpected JSON structure.")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.showAlert(message: "Failed to parse JSON response: \(error.localizedDescription)")
                }
            }
        }

        task.resume()
    }

    func getGoogleAPIKey() -> String? {
        if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: path) {
            return plist["API_KEY"] as? String
        }
        return nil
    }

    func showAlert(message: String) {
        self.alertMessage = message
        self.showAlert = true
    }
}

struct HandwritingView_Previews: PreviewProvider {
    static var previews: some View {
        // Corrected parameter order: 'korean' precedes 'english'
        HandwritingView(word: WordPair(korean: "자동차", english: "Car"))
    }
}
