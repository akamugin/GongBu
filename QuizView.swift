import SwiftUI

struct QuizView: View {
    let wordPairs: [WordPair]
    let totalQuestions: Int?  // nil for unlimited
    @State private var currentQuestionIndex: Int = 0
    @State private var userAnswers: [WordPair: Bool] = [:]  // Tracks correctness
    @State private var showingReview: Bool = false
    @State private var userInput: String = ""

    var body: some View {
        VStack(spacing: 30) {
            if currentQuestionIndex < questions.count {
                Text("Question \(currentQuestionIndex + 1)")
                    .font(.title)
                    .fontWeight(.bold)

                Text("What is the Korean word for \"\(questions[currentQuestionIndex].english)\"?")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()

                TextField("Enter Korean word", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .keyboardType(.default)

                Button(action: submitAnswer) {
                    Text("Submit")
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(BubblyButtonStyle(backgroundColor: Color.green))
                .padding(.horizontal)

                Spacer()
            } else {
                Button(action: {
                    showingReview = true
                }) {
                    Text("View Review")
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(BubblyButtonStyle(backgroundColor: Color.blue))
                .padding()

                Spacer()
            }
        }
        .padding()
        .sheet(isPresented: $showingReview) {
            ReviewView(userAnswers: userAnswers)
        }
    }

    // Generate questions based on totalQuestions
    var questions: [WordPair] {
        if let total = totalQuestions {
            return Array(wordPairs.shuffled().prefix(total))
        }
        return wordPairs.shuffled()
    }

    /// Submit the user's answer and proceed to the next question
    func submitAnswer() {
        let currentWord = questions[currentQuestionIndex]
        let isCorrect = userInput.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == currentWord.korean.lowercased()
        userAnswers[currentWord] = isCorrect
        userInput = ""
        currentQuestionIndex += 1

        // If reached the end and limited questions, show review
        if let total = totalQuestions, currentQuestionIndex >= total {
            showingReview = true
        }
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView(wordPairs: [
            WordPair(korean: "자동차", english: "Car"),
            WordPair(korean: "학교", english: "School"),
            WordPair(korean: "컴퓨터", english: "Computer"),
            WordPair(korean: "책", english: "Book"),
            WordPair(korean: "고양이", english: "Cat")
        ], totalQuestions: 5)
    }
}
