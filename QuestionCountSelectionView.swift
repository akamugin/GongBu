import SwiftUI

struct QuestionCountSelectionView: View {
    @EnvironmentObject var gameState: GameState
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .purple]),
                          startPoint: .top,
                          endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("How many questions would you like?")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                
                Button(action: { selectQuestionCount(5) }) {
                    QuestionCountButton(text: "5 Questions")
                }
                
                Button(action: { selectQuestionCount(10) }) {
                    QuestionCountButton(text: "10 Questions")
                }
                
                Button(action: { selectQuestionCount(15) }) {
                    QuestionCountButton(text: "15 Questions")
                }
                
                Button(action: { selectQuestionCount(0) }) {
                    QuestionCountButton(text: "Unlimited Questions")
                }
            }
            .padding()
        }
        .navigationBarHidden(true)
    }
    
    private func selectQuestionCount(_ count: Int) {
        gameState.questionCount = count
        // Navigate to game view
        gameState.currentView = .game
    }
}

struct QuestionCountButton: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
    }
}

// Preview provider for SwiftUI canvas
struct QuestionCountSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionCountSelectionView()
            .environmentObject(GameState())
    }
} 