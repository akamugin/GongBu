import SwiftUI

struct SpeakingView: View {
    @StateObject private var viewModel: SpeakingViewModel
    let onNext: () -> Void
    let onSkip: () -> Void
    
    @Environment(\.dismiss) private var dismiss

    init(word: WordPair, onNext: @escaping () -> Void, onSkip: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: SpeakingViewModel(word: word))
        self.onNext = onNext
        self.onSkip = onSkip
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                Text("Say the following word in Korean:")
                    .font(.headline)
                    .padding()

                Text(viewModel.word.english)
                    .font(.largeTitle)
                    .padding()

                // Recording Button
                Button(action: {
                    if viewModel.isRecording {
                        viewModel.stopRecording()
                    } else {
                        viewModel.startRecording()
                    }
                }) {
                    HStack {
                        if viewModel.isRecording {
                            Image(systemName: "stop.circle")
                        } else {
                            Image(systemName: "mic.circle")
                        }
                        Text(viewModel.isRecording ? "Stop Recording" : "Start Recording")
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                }
                .buttonStyle(
                    BubblyButtonStyle(
                        backgroundColor: viewModel.isRecording ? Color.red : Color(hex: "FFC0CB")
                    )
                )
                .disabled(viewModel.isLoading)

                // Navigation Buttons: Skip and Next
                HStack(spacing: 10) {
                    Button(action: {
                        onSkip()
                        dismiss()
                    }) {
                        Text("Skip")
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                    }
                    .buttonStyle(BubblyButtonStyle(backgroundColor: Color(hex: "FFC0CB")))

                    Button(action: {
                        onNext()
                        dismiss()
                    }) {
                        Text("Next")
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                    }
                    .buttonStyle(BubblyButtonStyle(backgroundColor: Color(hex: "FFC0CB")))
                }
                .padding([.leading, .trailing, .top])

                // Loading Indicator for Transcription
                if viewModel.isLoading {
                    ProgressView("Transcribing...")
                        .padding()
                }

                // Display the recognized text and correctness
                if !viewModel.resultText.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Recognized:")
                            .font(.subheadline)
                            .bold()

                        Text(viewModel.resultText)
                            .font(.body)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(8)

                        if let correct = viewModel.isCorrect {
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
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"),
                      message: Text(viewModel.alertMessage),
                      dismissButton: .default(Text("OK")))
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct SpeakingView_Previews: PreviewProvider {
    static var previews: some View {
        SpeakingView(
            word: WordPair(korean: "자동차", english: "Car"),
            onNext: {},
            onSkip: {}
        )
    }
}
