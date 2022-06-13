//
//  ProgressView.swift
//  Elva
//
//  Created by Arthur Guiot on 6/13/22.
//

import SwiftUI

struct HorizontalProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 0) {
            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(0.5, anchor: .center)
            configuration.label
        }.foregroundColor(.secondary)
    }
}

extension ProgressViewStyle where Self == HorizontalProgressViewStyle {
    static var horizontal: HorizontalProgressViewStyle { .init() }
}
