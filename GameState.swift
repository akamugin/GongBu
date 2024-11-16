import SwiftUI

class GameState: ObservableObject {
    // Navigation state
    @Published var currentView: AppView = .home
    
    // Game configuration
    @Published var selectedLevel: String = ""
    @Published var questionCount: Int = 0
    @Published var currentQuestionIndex: Int = 0
    
    // Score tracking
    @Published var score: Int = 0
    @Published var correctAnswers: Int = 0
    @Published var incorrectAnswers: Int = 0
    
    // Question management
    @Published var currentQuestion: String = ""
    @Published var currentAnswer: Int = 0
    @Published var userAnswer: String = ""
    
    // Game settings
    @Published var isGameActive: Bool = false
    @Published var showResults: Bool = false
    
    // Timer properties
    @Published var timeRemaining: Int = 60
    @Published var isTimerRunning: Bool = false
    
    // Question repetition
    @Published var questionRepetitions: Int?
    
    // Methods to manage game state
    func startNewGame() {
        score = 0
        correctAnswers = 0
        incorrectAnswers = 0
        currentQuestionIndex = 0
        isGameActive = true
        showResults = false
        timeRemaining = 60
        userAnswer = ""
    }
    
    func moveToNextQuestion() {
        if questionCount > 0 && currentQuestionIndex + 1 >= questionCount {
            endGame()
        } else {
            currentQuestionIndex += 1
            userAnswer = ""
        }
    }
    
    func endGame() {
        isGameActive = false
        showResults = true
        isTimerRunning = false
        currentView = .results
    }
    
    func resetGame() {
        currentView = .home
        selectedLevel = ""
        questionCount = 0
        startNewGame()
    }
}

enum AppView {
    case home
    case levelSelection
    case questionCount
    case game
    case results
}
