import SwiftUI

struct DesignView: View {
    @Binding var navigateToSelection: Bool

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.4)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                // Stars at the top
                HStack(spacing: 40) {
                    ForEach(0..<5) { _ in
                        VStack {
                            Rectangle()
                                .fill(Color.blue.opacity(0.5))
                                .frame(width: 2, height: 50)
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.top, 60)

                Spacer()

                // App Name
                Text("Gong Bu")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .padding(.bottom, 100)

                // Play Button
                Button(action: {
                    navigateToSelection = true  // Update the binding to navigate to the next page
                }) {
                    Text("Play")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.purple)
                        .cornerRadius(25)
                }
                .padding(.bottom, 40)

                Spacer()
            }
        }
    }
}

struct DesignView_Previews: PreviewProvider {
    static var previews: some View {
        DesignView(navigateToSelection: .constant(false))  // Provide constant for preview
    }
}
