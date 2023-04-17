//
//  SwiftUIView.swift
//  Nota
//
//  Created by Arthur Guiot on 29/08/2022.
//

import SwiftUI

class CommandPaletteController: NSViewController, OpenQuicklyDelegate {
    
    private var openQuicklyWindowController: OpenQuicklyWindowController?
    
    func toggle() {
        if (openQuicklyWindowController == nil) {
            let openQuicklyOptions = OpenQuicklyOptions()
            openQuicklyOptions.width = 500
            openQuicklyOptions.rowHeight = 50
            openQuicklyOptions.delegate = self
            openQuicklyOptions.placeholder = "Search for an action"
            self.openQuicklyWindowController = OpenQuicklyWindowController(options: openQuicklyOptions)
        }
        // Get active window frame
        let window = NSApplication.shared.mainWindow
        let frame = window?.frame
        // Calculate openQuickly window origin to be centered on the main window
        let originX = (frame?.origin.x)! + ((frame?.size.width)! / 2) - (openQuicklyWindowController?.window?.frame.size.width)! / 2
        let originY = (frame?.origin.y)! + ((frame?.size.height)! / 2) - (openQuicklyWindowController?.window?.frame.size.height)! / 2
        // Set openQuickly window origin
        openQuicklyWindowController?.toggle(with: NSPoint(x: originX, y: originY))
    }
    
    // MARK: Delegate
    func openQuickly(item: Any) -> NSView? {
        guard let action = item as? QuickAction else { return nil }
        
        let view = NSStackView()
        guard let image = NSImage(systemSymbolName: action.image, accessibilityDescription: nil) else { return nil }
        let imageView = NSImageView(image: image)
        
        let title = NSTextField()
        
        title.isEditable = false
        title.isBezeled = false
        title.isSelectable = false
        title.focusRingType = .none
        title.drawsBackground = false
        title.font = NSFont.systemFont(ofSize: 14)
        title.stringValue = action.name
        
        let subtitle = NSTextField()
        
        subtitle.isEditable = false
        subtitle.isBezeled = false
        subtitle.isSelectable = false
        subtitle.focusRingType = .none
        subtitle.drawsBackground = false
        subtitle.stringValue = action.subtitle
        subtitle.font = NSFont.systemFont(ofSize: 12)
        
        let text = NSStackView()
        text.orientation = .vertical
        text.spacing = 2.0
        text.alignment = .left
        
        text.addArrangedSubview(title)
        text.addArrangedSubview(subtitle)
        
        view.addArrangedSubview(imageView)
        view.addArrangedSubview(text)
        
        return view
    }
    
    let actions: [QuickAction] = [
        QuickAction(name: "New Document", subtitle: "Creates a new document in a new window", image: "doc.badge.plus", action: {
            NSDocumentController.shared.newDocument(nil)
        })
    ]
    
    @Preference(\.completionUsage) var tokenUsage
    
    func valueWasEntered(_ value: String) -> [Any] {
        var matches = actions.filter {
            $0.name.lowercased().contains(value.lowercased())
        }
        
        if value.numberOfWords >= 4 {
            matches.append(QuickAction(name: value, subtitle: "Let the AI write for you, using this prompt", image: "brain", action: {
                // Do nothing
                
                guard let document = NSDocumentController.shared.currentDocument as? MarkdownDocument else { return }
                
                let editionController = EditionController()
                document.networkActivity = true

                do {
                    let response = try await editionController.write(using: value, max_tokens: 256, stop: .none)
                    self.tokenUsage += TokenLimiter.shared.usage(for: response.usage.total_tokens, using: response.model)
                    document.selectionReplacement = response.choices.first?.text ?? ""
                } catch {
                    print(error)
                }
                
                document.networkActivity = false
            }))
        }
        
        return matches
    }
    
    func itemWasSelected(selected item: Any) {
        guard let action = item as? QuickAction else { return }
        Task {
            await action.action()
        }
        print("\(action.name) was selected")
    }
    
    func windowDidClose() {
        // Do nothing
    }
}
