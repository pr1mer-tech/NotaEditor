//
//  AppDelegate.swift
//  Elva
//
//  Created by Arthur Guiot on 6/18/22.
//

import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminate(_ sender: NSApplication)-> NSApplication.TerminateReply {
        return .terminateNow
    }
}

