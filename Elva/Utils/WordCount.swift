//
//  WordCount.swift
//  Elva
//
//  Created by Arthur Guiot on 6/13/22.
//

import Foundation

extension String {
    var numberOfWords: Int {
        var count = 0
        let range = startIndex..<endIndex
        enumerateSubstrings(in: range, options: [.byWords, .substringNotRequired, .localized], { _, _, _, _ -> () in
            count += 1
        })
        return count
    }
}
