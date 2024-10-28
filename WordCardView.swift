//
//  WordCardView.swift
//  GongBu
//
//  Created by Stella Lee on 10/28/24.
//


// GongBu/WordCardView.swift
import SwiftUI

struct WordCardView: View {
    let word: WordPair
    let onNext: () -> Void
    let onSkip: () -> Void

    var body: some View {
        VStack(spacing: 30) {
            Text(word.korean)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)

            Text(word.english)
                .font(.title2)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)

            HStack(spacing: 40) {
                Button(action: onSkip) {
                    Text("Skip")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 100)
                        .background(Color.red.opacity(0.7))
                        .cornerRadius(15)
                }

                Button(action: onNext) {
                    Text("Next")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 100)
                        .background(Color.green.opacity(0.7))
                        .cornerRadius(15)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.blue.opacity(0.6))
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        )
        .padding()
    }
}

struct WordCardView_Previews: PreviewProvider {
    static var previews: some View {
        WordCardView(
            word: WordPair(korean: "Apple", english: "A fruit that grows on trees."),
            onNext: {},
            onSkip: {}
        )
    }
}
