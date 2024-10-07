//
//  ContentView.swift
//  GongBu
//
//  Created by Stella Lee on 9/30/24.
// ContentView.swift

// ContentView.swift

import SwiftUI

struct ContentView: View {
    @State private var wordPairs: [WordPair] = []
    @State private var currentWord: WordPair?
    @State private var showingHandwritingView = false
    
    var body: some View {
        NavigationView {
            VStack {
                if let word = currentWord {
                    Text("Write the following word in Korean:")
                        .font(.headline)
                        .padding()
                    
                    Text(word.english)
                        .font(.largeTitle)
                        .padding()
                    
                    Button(action: {
                        showingHandwritingView = true
                    }) {
                        Text("Start Writing")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .sheet(isPresented: $showingHandwritingView) {
                        HandwritingView(word: word)
                    }
                } else {
                    Text("Loading words...")
                        .onAppear {
                            loadCSV()
                        }
                }
            }
            .navigationTitle("Gong Bu")
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
