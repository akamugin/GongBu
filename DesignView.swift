import SwiftUI

struct DesignView: View {
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 60) {
                Spacer()
                
                // Title for Selection
                Text("Choose Mode")
                    .font(Font.custom("AvenirNext-Bold", size: 60))
                    .foregroundColor(.white)
                    .shadow(color: Color.white.opacity(0.7), radius: 10, x: 0, y: 5)
                    .padding(.top, 50)
                
                Spacer()
                
                // Options: Speak and Write
                HStack(spacing: 40) {
                    // Speak Button
                    NavigationLink(destination: SelectionView(mode: .speak)) {
                        Text("Speak")
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: 150, height: 60)
                            .background(Color.green)
                            .cornerRadius(30)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
                    }
                    .buttonStyle(PlainButtonStyle()) // Apply custom styling
                    
                    // Write Button
                    NavigationLink(destination: HandwritingView()) {
                        Text("Write")
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: 150, height: 60)
                            .background(Color.pink)
                            .cornerRadius(30)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
                    }
                    .buttonStyle(PlainButtonStyle()) // Apply custom styling
                }
                
                Spacer()
                
                // Optional: Logout Button (If Applicable)
                /*
                Button(action: {
                    // Implement logout functionality if necessary
                }) {
                    Text("Logout")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red.opacity(0.7))
                        .cornerRadius(15)
                }
                .padding(.bottom, 50)
                */
            }
            .padding()
        }
        .navigationBarHidden(true) // Hide the navigation bar for a cleaner look
    }
}

struct DesignView_Previews: PreviewProvider {
    static var previews: some View {
        DesignView()
    }
}
