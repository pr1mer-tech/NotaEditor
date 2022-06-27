//
//  InfoRow.swift
//  Elva
//
//  Created by Arthur Guiot on 6/15/22.
//

import SwiftUI

struct InfoRow<T>: View where T: CustomStringConvertible {
    var label: LocalizedStringKey
    var value: T
    var body: some View {
        HStack {
            Text(label) +
            Text(":")
            Spacer()
            Text("\(String(describing: value))")
        }
    }
}
