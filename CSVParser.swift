// GongBu/CSVParser.swift
import Foundation

struct CSVParser {
    /// Parses CSV content into an array of WordPair objects.
    /// Assumes CSV format: term,definition
    static func parse(csvContent: String) -> [WordPair] {
        var wordPairs: [WordPair] = []
        let rows = csvContent.components(separatedBy: "\n")

        for row in rows {
            let columns = row.components(separatedBy: ",")
            if columns.count >= 2 {
                let term = columns[0].trimmingCharacters(in: .whitespacesAndNewlines)
                let definition = columns[1].trimmingCharacters(in: .whitespacesAndNewlines)
                let wordPair = WordPair(korean: term, english: definition)
                wordPairs.append(wordPair)
            }
        }

        return wordPairs
    }
}
