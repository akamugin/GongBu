import SwiftUI

struct ReviewView: View {
    let userAnswers: [WordPair: Bool]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(userAnswers.keys), id: \.self) { wordPair in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(wordPair.english)
                                .font(.headline)
                            Text(wordPair.korean)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Image(systemName: userAnswers[wordPair] == true ? "checkmark.circle" : "xmark.circle")
                            .foregroundColor(userAnswers[wordPair] == true ? .green : .red)
                            .imageScale(.large)
                    }
                    .padding(.vertical, 5)
                }
            }
            .navigationTitle("Review Answers")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    @Environment(\.dismiss) private var dismiss
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleAnswers: [WordPair: Bool] = [
            WordPair(korean: "자동차", english: "Car"): true,
            WordPair(korean: "학교", english: "School"): false
        ]
        ReviewView(userAnswers: sampleAnswers)
    }
}
