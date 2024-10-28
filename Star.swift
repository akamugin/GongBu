//
//  Star.swift
//  GongBu
//
//  Created by Stella Lee on 10/28/24.
//


import SwiftUI

struct Star: Identifiable {
    let id = UUID()
    let x: CGFloat        // Relative X position (0 to 1)
    let y: CGFloat        // Relative Y position (0 to 1)
    let size: CGFloat     // Size of the star
    let opacity: Double   // Opacity of the star
}

struct StarsView: View {
    private let starCount: Int = 100
    private var stars: [Star] = []

    init() {
        stars = (0..<starCount).map { _ in
            Star(
                x: CGFloat.random(in: 0...1),
                y: CGFloat.random(in: 0...1),
                size: CGFloat.random(in: 2...4),
                opacity: Double.random(in: 0.3...0.8)
            )
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(stars) { star in
                    Circle()
                        .foregroundColor(Color.white.opacity(star.opacity))
                        .frame(width: star.size, height: star.size)
                        .position(
                            x: geometry.size.width * star.x,
                            y: geometry.size.height * star.y
                        )
                }
            }
        }
        .drawingGroup()
    }
}

struct StarsView_Previews: PreviewProvider {
    static var previews: some View {
        StarsView()
    }
}