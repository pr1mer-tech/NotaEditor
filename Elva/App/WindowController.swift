//
//  WindowController.swift
//  Elva
//
//  Created by Arthur Guiot on 6/18/22.
//

import Cocoa

class WindowController: NSWindowController, NSWindowDelegate {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        /** NSWindows loaded from the storyboard will be cascaded
         based on the original frame of the window in the storyboard.
         */
        shouldCascadeWindows = true
    }
    
    override init(window: NSWindow?) {
        super.init(window: window)
        /** NSWindows loaded from the storyboard will be cascaded
         based on the original frame of the window in the storyboard.
         */
        shouldCascadeWindows = true
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.configureToolbar()
    }
    
    private func configureToolbar() {
        guard let window = self.window else { return }
        
        let toolbar = NSToolbar(identifier: "Main Window Toolbar")
        toolbar.delegate = self
        toolbar.allowsUserCustomization = false
        toolbar.displayMode = .iconOnly
        
        window.toolbar = toolbar
        window.toolbar?.validateVisibleItems()
    }
    
    // MARK: - Window Delegate
    func window(_ window: NSWindow, willUseFullScreenPresentationOptions proposedOptions: NSApplication.PresentationOptions = []) -> NSApplication.PresentationOptions {
        return [.autoHideToolbar, .autoHideMenuBar, .fullScreen]
    }
}
