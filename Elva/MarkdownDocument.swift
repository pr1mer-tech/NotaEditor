//
//  MarkdownDocument.swift
//  Elva
//
//  Created by Arthur Guiot on 6/13/22.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
  static let markdownDocument = UTType(
    exportedAs: "net.daringfireball.markdown")
}

struct MarkdownDocument: FileDocument {
    
    var content: String = ""
    
    static var readableContentTypes: [UTType] { [.markdownDocument] }
    
    init() {}
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
          throw CocoaError(.fileReadCorruptFile)
        }
        guard let str = String(data: data, encoding: .utf8) else {
            throw CocoaError(.fileReadUnknownStringEncoding)
        }
        self.content = str
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        guard let data = content.data(using: .utf8) else {
            throw CocoaError(.fileWriteInapplicableStringEncoding)
        }
        return FileWrapper(regularFileWithContents: data)
    }
}
