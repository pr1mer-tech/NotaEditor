//
//  Actions.swift
//  Elva
//
//  Created by Arthur Guiot on 29/08/2022.
//

import AppKit

struct QuickAction {
    var name: String
    var subtitle: String
    var image: String // SF Symbols
    var action: () async -> Void
}
