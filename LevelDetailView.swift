import SwiftUI

struct LevelDetailView: View {
    let csvFile: String
    @State private var wordPairs: [WordPair] = []
    @State private var currentWord: WordPair?
    @EnvironmentObject var gameState: GameState
    @State private var showQuestionCount = true
    @State private var currentQuestionNumber = 1

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "2E3192").opacity(0.1),
                    Color(hex: "1BFFFF").opacity(0.1)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            if showQuestionCount {
                VStack(spacing: 20) {
                    Text("How many questions?")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "2E3192"))
                        .padding(.bottom, 30)
                    
                    Button("5 Questions") {
                        gameState.questionCount = 5
                        gameState.questionRepetitions = 4
                        showQuestionCount = false
                        loadCSV()
                    }
                    .buttonStyle(BubblyButtonStyle(backgroundColor: Color(hex: "FF69B4")))
                    
                    Button("10 Questions") {
                        gameState.questionCount = 10
                        gameState.questionRepetitions = 9
                        showQuestionCount = false
                        loadCSV()
                    }
                    .buttonStyle(BubblyButtonStyle(backgroundColor: Color(hex: "FF69B4")))
                    
                    Button("15 Questions") {
                        gameState.questionCount = 15
                        gameState.questionRepetitions = 14
                        showQuestionCount = false
                        loadCSV()
                    }
                    .buttonStyle(BubblyButtonStyle(backgroundColor: Color(hex: "FF69B4")))
                    
                    Button("Unlimited") {
                        gameState.questionCount = 0
                        gameState.questionRepetitions = nil
                        showQuestionCount = false
                        loadCSV()
                    }
                    .buttonStyle(BubblyButtonStyle(backgroundColor: Color(hex: "FF69B4")))
                }
                .padding()
            } else {
                // Existing word exercise view
                VStack {
                    Text("Question \(currentQuestionNumber) of \(gameState.questionCount == 0 ? "∞" : "\(gameState.questionCount)")")
                        .font(.headline)
                        .padding(.top)
                    
                    if let word = currentWord {
                        VStack(spacing: 30) {
                            Text("Choose input type")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "2E3192"))
                                .padding(.top, 20)

                            Text(word.english)
                                .font(.system(size: 40, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "2E3192"))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.white)
                                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                                )
                                .padding(.horizontal)

                            // Writing Button
                            NavigationLink(destination: HandwritingView(word: word)) {
                                HStack {
                                    Image(systemName: "pencil.circle.fill")
                                        .font(.system(size: 24))
                                    Text("Writing")
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "FF69B4"))
                                .foregroundColor(.white)
                                .cornerRadius(15)
                                .shadow(color: Color(hex: "FF69B4").opacity(0.3), radius: 10, x: 0, y: 5)
                            }
                            .padding(.horizontal)

                            // Speaking Button
                            NavigationLink(destination: SpeakingView(word: word)) {
                                HStack {
                                    Image(systemName: "mic.circle.fill")
                                        .font(.system(size: 24))
                                    Text("Speaking")
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "FF69B4"))
                                .foregroundColor(.white)
                                .cornerRadius(15)
                                .shadow(color: Color(hex: "FF69B4").opacity(0.3), radius: 10, x: 0, y: 5)
                            }
                            .padding(.horizontal)
                        }

                        Button(action: handleNextQuestion) {
                            HStack {
                                Text(isLastQuestion ? "Finish" : "Next")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.system(size: 24))
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "4CAF50"))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(color: Color(hex: "4CAF50").opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    } else {
                        VStack {
                            Text("Loading words...")
                                .font(.system(size: 20, weight: .medium, design: .rounded))
                                .foregroundColor(Color(hex: "2E3192"))
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "FF69B4")))
                                .scaleEffect(1.5)
                        }
                        .onAppear {
                            loadCSV()
                        }
                    }
                }
                .padding(.top)
            }
        }
    }

    private var isLastQuestion: Bool {
        if gameState.questionCount == 0 { return false }  // Unlimited mode
        return currentQuestionNumber >= gameState.questionCount
    }

    private func handleNextQuestion() {
        if isLastQuestion {
            // Handle end of questions (navigate back or show results)
            gameState.currentView = .results
        } else {
            // Move to next question
            currentQuestionNumber += 1
            // Optionally shuffle to a new word from wordPairs
            if !wordPairs.isEmpty {
                currentWord = wordPairs.randomElement()
            }
        }
    }

    func loadCSV() {
        if let filepath = Bundle.main.path(forResource: csvFile, ofType: "csv") {
            do {
                let contents = try String(contentsOfFile: filepath)
                wordPairs = CSVParser.parse(csvContent: contents)
                if let firstWord = wordPairs.randomElement() {
                    currentWord = firstWord
                }
                print("Loaded \(wordPairs.count) word pairs from \(csvFile).csv")
            } catch {
                print("Error loading CSV file \(csvFile).csv: \(error.localizedDescription)")
            }
        } else {
            print("CSV file \(csvFile).csv not found.")
        }
    }
} 
