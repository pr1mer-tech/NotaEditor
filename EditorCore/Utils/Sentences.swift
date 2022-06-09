//
//  Sentences.swift
//  EditorCore
//
//  Created by Arthur Guiot on 6/9/22.
//

import NaturalLanguage

extension String {
    var sentences: [String] {
        var result: [String] = []
        let tagger = NLTagger(tagSchemes: [.lexicalClass])
        tagger.string = self
        tagger.enumerateTags(in: startIndex..<endIndex, unit: .sentence, scheme: .lexicalClass) { (tag, tokenRange) -> Bool in
            result.append(String(self[tokenRange]))
            return true
        }
        return result
    }
}
