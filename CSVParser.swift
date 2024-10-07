//
//  CSVParser.swift
//  GongBu
//
//  Created by Stella Lee on 9/30/24.
//


// CSVParser.swift

import Foundation

struct CSVParser {
    static func parse(csvContent: String) -> [WordPair] {
        var wordPairs: [WordPair] = []
        let rows = csvContent.components(separatedBy: "\n")
        
        for row in rows {
            let columns = row.components(separatedBy: ",")
            if columns.count >= 2 {
                let korean = columns[0].trimmingCharacters(in: .whitespacesAndNewlines)
                let english = columns[1].trimmingCharacters(in: .whitespacesAndNewlines)
                let wordPair = WordPair(korean: korean, english: english)
                wordPairs.append(wordPair)
            }
        }
        return wordPairs
    }
}
