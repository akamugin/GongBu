import SwiftUI

struct ContentView: View {
    @Binding var navigateToSelection: Bool  // Step 1: Use binding to track the navigation state
    @State private var wordPairs: [WordPair] = []
    @State private var currentWord: WordPair?

    var body: some View {
        ZStack {
            // Full-screen DesignView background
            if !navigateToSelection {
                DesignView(navigateToSelection: $navigateToSelection)
                    .ignoresSafeArea()  // Ensure DesignView takes up the full screen
            } else {
                Color.blue.opacity(0.1).ignoresSafeArea()  // Background color for selection screen

                VStack {
                    if let word = currentWord {
                        VStack {
                            Text("Choose input type")
                                .font(.headline)
                                .padding()

                            Text(word.english)
                                .font(.largeTitle)
                                .padding()

                            // Writing Button
                            NavigationLink(destination: HandwritingView(word: word)) {
                                Text("Writing")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .padding(.bottom)

//                            // Speaking Button
//                            NavigationLink(destination: SpeakingView(word: word)) {
//                                Text("Speaking")
//                                    .padding()
//                                    .background(Color.orange)
//                                    .foregroundColor(.white)
//                                    .cornerRadius(8)
//                            }
                        }
                    } else {
                        Text("Loading words...")
                            .onAppear {
                                loadCSV()
                            }
                    }
                }
                .padding()
            }
        }
    }

    func loadCSV() {
        if let filepath = Bundle.main.path(forResource: "vocab", ofType: "csv") {
            do {
                let contents = try String(contentsOfFile: filepath)
                wordPairs = CSVParser.parse(csvContent: contents)
                if let firstWord = wordPairs.randomElement() {
                    currentWord = firstWord
                }
                print("Loaded \(wordPairs.count) word pairs.")
            } catch {
                print("Error loading CSV file.")
            }
        } else {
            print("CSV file not found.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(navigateToSelection: .constant(false))  // Pass constant binding for preview
    }
}
