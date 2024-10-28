import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 60) {
                    Spacer()
                    
                    // App Title "Gong Bu" with Bubbly Font
                    Text("Gong Bu")
                        .font(Font.custom("AvenirNext-Bold", size: 80))
                        .foregroundColor(.white)
                        .shadow(color: Color.white.opacity(0.7), radius: 10, x: 0, y: 5)
                        .padding(.top, 100)
                    
                    Spacer()
                    
                    // Play Button leading to DesignView
                    NavigationLink(destination: DesignView()) {
                        Text("Play")
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 60)
                            .background(Color.pink)
                            .cornerRadius(30)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
                    }
                    .buttonStyle(PlainButtonStyle()) // Apply custom styling
                    .padding(.bottom, 100)
                }
            }
            .navigationBarHidden(true) // Hide the navigation bar for a cleaner look
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
