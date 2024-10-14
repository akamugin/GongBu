import AVFoundation

class AudioRecorder: NSObject, AVAudioRecorderDelegate {
    private var audioRecorder: AVAudioRecorder?
    private var recordingSession: AVAudioSession = AVAudioSession.sharedInstance()

    func startRecording() throws {
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentsDirectory.appendingPathComponent("recording.m4a")

        try recordingSession.setCategory(.playAndRecord, mode: .default)
        try recordingSession.setActive(true)

        audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
        audioRecorder?.delegate = self
        audioRecorder?.record()
    }

    func stopRecording(completion: @escaping (Result<URL, Error>) -> Void) {
        audioRecorder?.stop()
        audioRecorder = nil

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentsDirectory.appendingPathComponent("recording.m4a")

        completion(.success(audioFilename))
    }
}
