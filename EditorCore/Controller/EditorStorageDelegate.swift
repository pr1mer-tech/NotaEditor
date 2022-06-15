//
//  EditorStatisticDelegate.swift
//  EditorCore
//
//  Created by Arthur Guiot on 6/13/22.
//

import Foundation
import AppKit

public protocol EditorStorageDelegate: NSTextStorageDelegate {
    var shouldUpdateText: Bool { get set }
    func startedCompletionActivity(with request: CompletionRequest) -> Void
    func finishedCompletionActivity(with response: CompletionResponse) -> Void
}
