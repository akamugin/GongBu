//
//  SpeakingViewModel.swift
//  GongBu
//
//  Created by Stella Lee on 10/13/24.
//

import Foundation
import FirebaseVertexAI

class SpeakingViewModel: ObservableObject {
    @Published var isRecording: Bool = false
    @Published var isLoading: Bool = false
    @Published var resultText: String = ""
    @Published var isCorrect: Bool?
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""

    private let audioRecorder = AudioRecorder()

    let word: WordPair

    init(word: WordPair) {
        self.word = word
    }

    /// Initiates the audio recording process.
    func startRecording() {
        do {
            try audioRecorder.startRecording()
            DispatchQueue.main.async {
                self.isRecording = true
                self.resultText = ""
                self.isCorrect = nil
            }
        } catch {
            DispatchQueue.main.async {
                self.showAlert(message: "Unable to start recording: \(error.localizedDescription)")
            }
        }
    }

    /// Stops the audio recording and initiates transcription.
    func stopRecording() {
        audioRecorder.stopRecording { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isRecording = false
            }
            switch result {
            case .success(let audioURL):
                self.transcribeAudio(audioURL: audioURL)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(message: "Recording failed: \(error.localizedDescription)")
                }
            }
        }
    }

    /// Transcribes the recorded audio using Firebase Vertex AI.
    /// - Parameter audioURL: The URL of the recorded audio file.
    private func transcribeAudio(audioURL: URL) {
        isLoading = true
        Task {
            let prompt = "Write in JSON output key called \"korean\" that contains the korean letters spoken."
            let recognizedText = await GoogleCloudAPI.recognizeSpeech(audioURL: audioURL, prompt: prompt)
            
            DispatchQueue.main.async {
                self.isLoading = false
                if !recognizedText.isEmpty {
                    self.resultText = recognizedText
                    self.isCorrect = (recognizedText.lowercased() == self.word.korean.lowercased())
                } else {
                    self.resultText = "No Korean text detected."
                    self.isCorrect = false
                }
            }
        }
    }

    /// Displays an alert with the provided message.
    /// - Parameter message: The message to display in the alert.
    private func showAlert(message: String) {
        DispatchQueue.main.async {
            self.alertMessage = message
            self.showAlert = true
        }
    }
}