//
//  Stats.swift
//  Elva
//
//  Created by Arthur Guiot on 6/13/22.
//

import Foundation


class Stats: ObservableObject {
    @Published var networkActivity = false
    @Published var wordCount: Int = 0
}
