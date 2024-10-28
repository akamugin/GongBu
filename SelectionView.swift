// GongBu/SelectionView.swift
import SwiftUI

enum Mode {
    case speak
    case write
}
struct SelectionView: View {
    @EnvironmentObject var appState: AppState  // Access AppState from the environment
    @State private var navigateToWordDetails: Bool = false
    @State private var wordPairs: [WordPair] = []
    @State private var currentIndex: Int = 0
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            if currentWord != nil {
                WordCardView(word: currentWord!,
                             onNext: {
                                 nextWord()
                             },
                             onSkip: {
                                 skipWord()
                             })
                    .transition(.slide)
            } else {
                ProgressView("Loading Words...")
                    .foregroundColor(.white)
            }
        }
        .onAppear {
            loadWords()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    /// Loads words from the CSV file
    private func loadWords() {
        if let filepath = Bundle.main.path(forResource: "vocab", ofType: "csv") {
            do {
                let contents = try String(contentsOfFile: filepath)
                wordPairs = CSVParser.parse(csvContent: contents)
                if !wordPairs.isEmpty {
                    currentIndex = 0
                }
            } catch {
                alertMessage = "Failed to load words: \(error.localizedDescription)"
                showAlert = true
            }
        } else {
            alertMessage = "CSV file not found."
            showAlert = true
        }
    }

    /// Retrieves the current word based on the index
    private var currentWord: WordPair? {
        guard !wordPairs.isEmpty else { return nil }
        return wordPairs[currentIndex]
    }

    /// Advances to the next word
    private func nextWord() {
        if currentIndex < wordPairs.count - 1 {
            currentIndex += 1
        } else {
            // Reached the end of the list
            alertMessage = "You've reached the end of the word list."
            showAlert = true
        }
    }

    /// Skips the current word and moves to the next
    private func skipWord() {
        if currentIndex < wordPairs.count - 1 {
            currentIndex += 1
        } else {
            // Reached the end of the list
            alertMessage = "No more words to skip."
            showAlert = true
        }
    }
}

struct SelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionView()
            .environmentObject(AppState())
    }
}
