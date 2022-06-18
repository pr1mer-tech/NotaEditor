//
//  ToolbarDelegate.swift
//  Elva
//
//  Created by Arthur Guiot on 6/18/22.
//

import Cocoa


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
        
        return nil
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            .flexibleSpace,
            .inspectorToggle,
        ]
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            .flexibleSpace,
            .inspectorToggle,
        ]
    }
    
    // MARK: - Actions
    @objc func toggleInspector(_ sender: Any) {
        toolbarManager.showInspector.toggle()
    }
}
