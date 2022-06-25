//
//  Theme.swift
//  EditorCore
//
//  Created by Rudd Fawcett on 10/14/16.
//  Copyright © 2016 Rudd Fawcett. All rights reserved.
//

#if os(iOS)
    import UIKit
#elseif os(macOS)
    import AppKit
#endif

public struct Theme {

    /// The body style for the EditorCore editor.
    public var body: Style = Style()
    /// The background color of the EditorCore.
    public var backgroundColor: UniversalColor = UniversalColor.clear
    /// The tint color (AKA cursor color) of the EditorCore.
    public var tintColor: UniversalColor = UniversalColor.blue

    /// All of the other styles for the EditorCore editor.
    public var styles: [Style] = []
    
    public init(styles: [Style]) {
        self.body = styles.first { $0.element == .body } ?? Style(element: .body, attributes: [.foregroundColor: UniversalColor.label])
        self.styles = styles.filter { $0.element != .body }
    }
    
    public static var `default`: Theme {
        let styles: [Style] = [
            Style(element: .h1, hiddenOffset: 1, attributes: [
                .font: UniversalFont.boldSystemFont(ofSize: 32),
            ]),
            Style(element: .h2, hiddenOffset: 2, attributes: [
                .font: UniversalFont.boldSystemFont(ofSize: 28),
            ]),
            Style(element: .h3, hiddenOffset: 3, attributes: [
                .font: UniversalFont.systemFont(ofSize: 22),
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .underlineColor: UniversalColor.gray,
            ]),
            Style(element: .body, attributes: [
                .font: UniversalFont.systemFont(ofSize: 17),
                .foregroundColor: UniversalColor.labelColor,
            ]),
            Style(element: .bold, attributes: [
                .font: UniversalFont.systemFont(ofSize: 17).with(traits: "bold"),
            ]),
            Style(element: .italic, attributes: [
                .font: UniversalFont.systemFont(ofSize: 17).with(traits: "italic"),
            ]),
            Style(element: .code, attributes: [
                .foregroundColor: UniversalColor.systemCyan,
            ]),
            Style(regex: "[@＠][a-zA-Z0-9_]{1,20}".toRegex(), attributes: [
                .foregroundColor: UniversalColor.systemBlue,
            ]),
            Style(element: .url, attributes: [
                .foregroundColor: UniversalColor.systemBlue,
            ]),
            Style(element: .image, attributes: [
                .foregroundColor: UniversalColor.systemRed,
            ]),
        ]
        return Theme(styles: styles)
    }
}
