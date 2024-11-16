import SwiftUI

struct ShimmeringStarView: View {
    @State private var isShimmering = false
    let delay: Double
    
    var body: some View {
        VStack {
            Image(systemName: "star.fill")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
                .opacity(isShimmering ? 0.5 : 1.0)
                .scaleEffect(isShimmering ? 0.8 : 1.2)
                .animation(
                    Animation.easeInOut(duration: 1.5)
                        .repeatForever()
                        .delay(delay),
                    value: isShimmering
                )
                .onAppear {
                    isShimmering = true
                }
        }
    }
}

struct BubblyButtonStyle: ButtonStyle {
    let backgroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 24, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .padding()
            .frame(width: 200, height: 50)
            .background(backgroundColor)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.2), lineWidth: 2)
            )
            .shadow(color: backgroundColor.opacity(0.3), radius: 10, x: 0, y: 5)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct DesignView: View {
    @Binding var navigateToSelection: Bool
    @State private var titleOffset: CGFloat = 1000
    @State private var buttonOffset: CGFloat = 1000
    @State private var showLevelSelection = false
    
    var body: some View {
        ZStack {
            // Animated gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "2E3192"),
                    Color(hex: "1BFFFF")
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Floating stars
            ForEach(0..<20) { index in
                ShimmeringStarView(delay: Double(index) * 0.1)
                    .position(
                        x: CGFloat.random(in: 50...UIScreen.main.bounds.width-50),
                        y: CGFloat.random(in: 50...UIScreen.main.bounds.height-50)
                    )
            }
            
            VStack(spacing: 40) {
                Spacer()
                
                // App Title with animation
                Text("GongBu")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .white.opacity(0.7)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    .offset(y: titleOffset)
                    .onAppear {
                        withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                            titleOffset = 0
                        }
                    }
                
                Text("Learn Korean")
                    .font(.system(size: 24, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
                    .offset(y: titleOffset)
                
                Spacer()
                
                // Start Learning Button with animation
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        showLevelSelection = true
                    }
                }) {
                    Text("Start Learning")
                }
                .buttonStyle(BubblyButtonStyle(backgroundColor: Color(hex: "FF69B4")))
                .offset(y: buttonOffset)
                .onAppear {
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2)) {
                        buttonOffset = 0
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .sheet(isPresented: $showLevelSelection) {
            NavigationView { // Wrap in NavigationView for nested navigation
                LevelSelectionView()
            }
        }
    }
}

// Helper extension for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct DesignView_Previews: PreviewProvider {
    static var previews: some View {
        DesignView(navigateToSelection: .constant(false))
    }
}
