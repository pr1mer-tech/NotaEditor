//
//  WindowController.swift
//  Elva
//
//  Created by Arthur Guiot on 6/18/22.
//

import Cocoa

class WindowController: NSWindowController, NSWindowDelegate {
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        /** NSWindows loaded from the storyboard will be cascaded
         based on the original frame of the window in the storyboard.
         */
        shouldCascadeWindows = true
    }
    
}
