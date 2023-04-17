//
//  ToolbarDelegate.swift
//  Nota
//
//  Created by Arthur Guiot on 6/18/22.
//

import Cocoa
import SwiftUI


// MARK: - Toolbar Delegate

extension WindowController: NSToolbarDelegate {
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        let item = NSToolbarItem(itemIdentifier: itemIdentifier)
        item.target = self
        item.isBordered = true
        if itemIdentifier == .inspectorToggle {
            item.action = #selector(toggleInspector(_:))
            item.label = "Inspector"
            item.paletteLabel = "Show/Hide inspector bar"
            item.image = NSImage(systemSymbolName: "sidebar.right", accessibilityDescription: "Toggle Right Sidebar")
            return item
        }
        // 2) This is how we create the tracking separator, and we provide a reference to the splitview
        else if itemIdentifier == .trackingSplitItem {
            guard let splitViewController = self.contentViewController as? NSSplitViewController else { return nil }
            return NSTrackingSeparatorToolbarItem(identifier: .trackingSplitItem,
                                                         splitView: splitViewController.splitView,
                                                         dividerIndex: 0)
        }
        
        return nil
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            .flexibleSpace,
            .inspectorToggle,
            .trackingSplitItem
        ]
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            .flexibleSpace,
            .inspectorToggle,
            .trackingSplitItem
        ]
    }
    
    // MARK: - Actions
    @objc func toggleInspector(_ sender: Any) {
        guard let splitViewController = self.contentViewController as? MasterInspectorLayoutView else { return }
        splitViewController.toggleSidebar(sender)
        
        if splitViewController.detailItem.isCollapsed {
            self.window?.toolbar?.removeItem(at: 2)
        } else {
            self.window?.toolbar?.insertItem(withItemIdentifier: .trackingSplitItem, at: 2)
        }
    }
}
