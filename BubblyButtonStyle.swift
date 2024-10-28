import SwiftUI

struct BubblyButtonStyle: ButtonStyle {
    var backgroundColor: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(15)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: configuration.isPressed)
    }
}

struct BubblyButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button("Bubbly Button") {
            // Action
        }
        .buttonStyle(BubblyButtonStyle(backgroundColor: Color.pink))
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
