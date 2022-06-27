//
//  EditorCore-macOS.swift
//  EditorCore
//
//  Created by Christian Tietze on 2017-07-21.
//  Copyright © 2017 Rudd Fawcett. All rights reserved.
//

#if os(macOS)
import AppKit
import STTextView
public class EditorCore: STTextView {
    var storage: Storage = Storage() {
        didSet {
            self.textContentStorage.textStorage = storage
        }
    }
    
    var networkTask: Task<(), Never>? = nil
    
    public override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        
        // Stop tasks
        self.networkTask?.cancel()
        
        // Delete completion
        guard let gptRange = attributedString().GPTCompletionRange else { return }
        textContentStorage.textStorage?
            .replaceCharacters(in: gptRange, with: "") // Removing completion
    }
    
    override public func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        NSCursor.iBeam.set()
    }
    
    private var trackingArea: NSTrackingArea?
    
    public override func updateTrackingAreas() {
        super.updateTrackingAreas()
        
        if let trackingArea = self.trackingArea {
            self.removeTrackingArea(trackingArea)
        }
        
        let options: NSTrackingArea.Options = [.mouseEnteredAndExited, .activeAlways]
        self.trackingArea = NSTrackingArea(rect: self.bounds, options: options, owner: self, userInfo: nil)
        self.addTrackingArea(self.trackingArea!)
    }
    
    public override func viewDidChangeEffectiveAppearance() {
        
    }
}
#endif
