//
//  MasterInspectorLayoutView.swift
//  Elva
//
//  Created by Arthur Guiot on 6/17/22.
//

import SwiftUI

class MasterInspectorLayoutView: NSSplitViewController {
    weak var document: MarkdownDocument!
    
    lazy var masterItem: NSSplitViewItem = {
        let controller = NSHostingController(rootView: EditorView().environmentObject(document))
        let item = NSSplitViewItem(viewController: controller)
        return item
    }()

    lazy var detailItem: NSSplitViewItem = {
        let pane = SmartPane()
            .frame(maxHeight: .infinity)
            .visualEffect(material: .sidebar)
            .environmentObject(document)
        let controller = NSHostingController(rootView: pane)
        let item = NSSplitViewItem(sidebarWithViewController: controller)
        return item
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Styling
        self.splitView.dividerStyle = .thin
        
        // Subview styling
        detailItem.titlebarSeparatorStyle = .line
        
        detailItem.allowsFullHeightLayout = true
        
        detailItem.holdingPriority = .defaultHigh
        // Subviews
        self.addSplitViewItem(masterItem)
        self.addSplitViewItem(detailItem)
    }

    override func splitView(_ splitView: NSSplitView, effectiveRect proposedEffectiveRect: NSRect, forDrawnRect drawnRect: NSRect, ofDividerAt dividerIndex: Int) -> NSRect {
        return NSZeroRect
    }
    
    
}
