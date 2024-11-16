import SwiftUI

struct ContentView: View {
    @Binding var navigateToSelection: Bool
    @State private var wordPairs: [WordPair] = []
    @State private var currentWord: WordPair?
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            if !navigateToSelection {
                DesignView(navigateToSelection: $navigateToSelection)
                    .ignoresSafeArea()
            } else {
                // Background gradient for consistency
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "2E3192").opacity(0.1),
                        Color(hex: "1BFFFF").opacity(0.1)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack {
                    // Back button at the top
                    HStack {
//                        BackButtonView(navigateToSelection: $navigateToSelection)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
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
                    
                    Spacer()
                }
                .padding(.top)
            }
        }
    }

    func loadCSV() {
        let selectedLevel = UserDefaults.standard.string(forKey: "selectedLevel") ?? "1101.1"
        
        if let filepath = Bundle.main.path(forResource: selectedLevel, ofType: "csv") {
            do {
                let contents = try String(contentsOfFile: filepath)
                wordPairs = CSVParser.parse(csvContent: contents)
                if let firstWord = wordPairs.randomElement() {
                    currentWord = firstWord
                }
                print("Loaded \(wordPairs.count) word pairs from \(selectedLevel).csv")
            } catch {
                print("Error loading CSV file \(selectedLevel).csv: \(error.localizedDescription)")
            }
        } else {
            print("CSV file \(selectedLevel).csv not found.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(navigateToSelection: .constant(false))
    }
}
