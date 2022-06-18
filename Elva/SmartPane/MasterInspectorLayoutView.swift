//
//  MasterInspectorLayoutView.swift
//  Elva
//
//  Created by Arthur Guiot on 6/17/22.
//

import SwiftUI

class MasterInspectorLayoutView: NSSplitViewController {
    var masterItem: NSSplitViewItem {
        return self.splitViewItems[0]
    }

    var detailItem: NSSplitViewItem {
        return self.splitViewItems[1]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Styling
        self.splitView.dividerStyle = .thin

        // Subviews
        detailItem.titlebarSeparatorStyle = .line
        
        detailItem.allowsFullHeightLayout = true
        
        detailItem.holdingPriority = .defaultHigh
    }

    override func splitView(_ splitView: NSSplitView, effectiveRect proposedEffectiveRect: NSRect, forDrawnRect drawnRect: NSRect, ofDividerAt dividerIndex: Int) -> NSRect {
        return NSZeroRect
    }
    
    
}
