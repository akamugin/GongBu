//
//  AudioRecorder.swift
//  GongBu
//
//  Created by Stella Lee on 10/13/24.
//

import AVFoundation

class AudioRecorder: NSObject, AVAudioRecorderDelegate {
    private var audioRecorder: AVAudioRecorder?
    private var recordingSession: AVAudioSession = AVAudioSession.sharedInstance()

    /// Starts recording audio and saves it to a WAV file.
    /// - Throws: An error if recording cannot be started.
    func startRecording() throws {
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM), // Use Linear PCM for WAV
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
            AVLinearPCMBitDepthKey: 16,
            AVLinearPCMIsFloatKey: false,
            AVLinearPCMIsBigEndianKey: false
        ]

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentsDirectory.appendingPathComponent("recording.wav") // WAV format

        try recordingSession.setCategory(.playAndRecord, mode: .default)
        try recordingSession.setActive(true)

        audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
        audioRecorder?.delegate = self
        audioRecorder?.record()
    }

    /// Stops recording and returns the audio file URL or an error.
    /// - Parameter completion: Completion handler with the result.
    func stopRecording(completion: @escaping (Result<URL, Error>) -> Void) {
        audioRecorder?.stop()
        audioRecorder = nil

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentsDirectory.appendingPathComponent("recording.wav") // Ensure consistency

        // Check if the file exists
        if FileManager.default.fileExists(atPath: audioFilename.path) {
            completion(.success(audioFilename))
        } else {
            let error = NSError(domain: "AudioRecorder", code: 1, userInfo: [NSLocalizedDescriptionKey: "Audio file not found."])
            completion(.failure(error))
        }
    }
}