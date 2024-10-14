//
//  SpeakingViewModel.swift
//  GongBu
//
//  Created by Stella Lee on 10/13/24.
//


import Foundation
import AVFoundation
import Speech

class SpeakingViewModel: ObservableObject {
    @Published var isRecording: Bool = false
    @Published var isLoading: Bool = false
    @Published var resultText: String = ""
    @Published var isCorrect: Bool?
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""

    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    let word: WordPair

    init(word: WordPair) {
        self.word = word
    }

    func startRecording() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                DispatchQueue.main.async {
                    self.isRecording = true
                    self.startSpeechRecognition()
                }
            default:
                DispatchQueue.main.async {
                    self.showAlert(message: "Speech recognition authorization was not granted.")
                }
            }
        }
    }

    func stopRecording() {
        audioEngine.stop()
        request?.endAudio()
        recognitionTask?.cancel()
        isRecording = false
    }

    private func startSpeechRecognition() {
        isLoading = true
        request = SFSpeechAudioBufferRecognitionRequest()

        guard let inputNode = audioEngine.inputNode as AVAudioInputNode?,
              let request = request else {
            showAlert(message: "Unable to create audio request.")
            return
        }

        request.shouldReportPartialResults = true

        recognitionTask = speechRecognizer?.recognitionTask(with: request) { [weak self] result, error in
            guard let self = self else { return }

            if let result = result {
                DispatchQueue.main.async {
                    self.resultText = result.bestTranscription.formattedString
                    self.isCorrect = (result.bestTranscription.formattedString.lowercased() == self.word.korean.lowercased())
                    self.isLoading = false
                }
            }

            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(message: "Speech recognition error: \(error.localizedDescription)")
                    self.isLoading = false
                }
            }
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request?.append(buffer)
        }

        audioEngine.prepare()

        do {
            try audioEngine.start()
        } catch {
            showAlert(message: "Audio Engine couldn't start: \(error.localizedDescription)")
            isLoading = false
        }
    }

    private func showAlert(message: String) {
        self.alertMessage = message
        self.showAlert = true
    }
}
