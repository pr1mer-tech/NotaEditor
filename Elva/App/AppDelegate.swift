//
//  AppDelegate.swift
//  Elva
//
//  Created by Arthur Guiot on 6/18/22.
//

import SwiftUI
import Preferences

@main
final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminate(_ sender: NSApplication)-> NSApplication.TerminateReply {
        return .terminateNow
    }
    
    @IBAction
    func settingsMenuItemActionHandler(_ sender: NSMenuItem) {
        settingsWindowController.show()
    }
    
    private lazy var settingsWindowController = SettingsWindowController(panes: [
        Settings.Pane(
            identifier: .usage,
            title: "Usage",
            toolbarIcon: NSImage(systemSymbolName: "speedometer", accessibilityDescription: "Smart Completion Usage")!
        ) {
            PreferenceUsagePane()
        },
    ], style: .toolbarItems, animated: true, hidesToolbarForSingleItem: false)
}

