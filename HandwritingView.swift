import SwiftUI

struct HandwritingView: View {
    @State private var drawnLines: [Line] = []
    @State private var currentLine: Line = Line(points: [])

    var body: some View {
        VStack {
            // Handwriting Canvas
            DrawingCanvas(drawnLines: $drawnLines, currentLine: $currentLine)
                .background(Color.white)
                .border(Color.gray, width: 1)
                .padding()

            // Buttons
            HStack(spacing: 40) {
                Button(action: clearCanvas) {
                    Text("Clear")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 100, height: 50)
                        .background(Color.red)
                        .cornerRadius(15)
                }
                .buttonStyle(PlainButtonStyle())

                Button(action: submitDrawing) {
                    Text("Submit")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 100, height: 50)
                        .background(Color.green)
                        .cornerRadius(15)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()

            Spacer()
        }
        .navigationTitle("Handwriting")
        .navigationBarTitleDisplayMode(.inline)
    }

    /// Clears the drawing canvas
    func clearCanvas() {
        drawnLines.removeAll()
    }

    /// Submits the drawing for processing
    func submitDrawing() {
        // Implement your handwriting processing logic here
        print("Drawing submitted.")
    }
}

struct HandwritingView_Previews: PreviewProvider {
    static var previews: some View {
        HandwritingView()
    }
}

// MARK: - Drawing Canvas Components

struct DrawingCanvas: View {
    @Binding var drawnLines: [Line]
    @Binding var currentLine: Line

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Existing Drawn Lines
                ForEach(drawnLines) { line in
                    Path { path in
                        guard let firstPoint = line.points.first else { return }
                        path.move(to: firstPoint)
                        for point in line.points.dropFirst() {
                            path.addLine(to: point)
                        }
                    }
                    .stroke(Color.blue, lineWidth: 2)
                }

                // Current Drawing Line
                Path { path in
                    guard let firstPoint = currentLine.points.first else { return }
                    path.move(to: firstPoint)
                    for point in currentLine.points.dropFirst() {
                        path.addLine(to: point)
                    }
                }
                .stroke(Color.blue, lineWidth: 2)
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0.1)
                    .onChanged { value in
                        let location = value.location
                        currentLine.points.append(location)
                    }
                    .onEnded { _ in
                        drawnLines.append(currentLine)
                        currentLine = Line(points: [])
                    }
            )
        }
    }
}

struct Line: Identifiable {
    let id = UUID()
    var points: [CGPoint]
}
