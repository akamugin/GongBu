import SwiftUI

struct LevelSelectionView: View {

    // Define levels with their corresponding CSV file names
    let levels: [(title: String, csvFile: String)] = [
        ("1101.1", "1101.1"),
        ("1101.2", "1101.2"),
        ("1101.3", "1101.3"),
        ("1101.4", "1101.4"),
        ("2201.1", "2201.1"),
        ("2201.2", "2201.2"),
        ("2201.3", "2201.3"),
        ("2201.4", "2201.4")
    ]

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "2E3192"),
                    Color(hex: "1BFFFF")
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                Text("Select Level")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 30)
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(levels, id: \.title) { level in
                            NavigationLink(destination: LevelDetailView(csvFile: level.csvFile)) {
                                Text(level.title)
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .frame(maxWidth: .infinity, minHeight: 70)
                                    .foregroundColor(.white)
                            }
                            .buttonStyle(BubblyButtonStyle(backgroundColor: Color(hex: "FF69B4")))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

//struct LevelDetailView: View {
//    let csvFile: String
//
//    var body: some View {
//        VStack {
//            Text("Quiz for level \(csvFile)")
//                .font(.title)
//                .padding()
//            // Here you can add more quiz-related content or functionality
//            
//        }
//        .navigationBarTitle("Level \(csvFile)", displayMode: .inline)
//    }
//}
