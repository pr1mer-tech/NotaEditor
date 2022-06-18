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
    
    override func splitView(_ splitView: NSSplitView, canCollapseSubview subview: NSView) -> Bool {
        var result = false
        if splitView == self.splitView && subview == self.detailItem.viewController.view {
            result = true
        }
        return result
    }
    
    var lastInspectorWidth: CGFloat = 300
    
    func toggleInspector(showDetail: Bool) {
        self.detailItem.isCollapsed = !showDetail
        if (showDetail) {
            // NSSplitView hides the collapsed subview
            self.detailItem.viewController.view.isHidden = false

            var expandMainAnimationDict = [NSViewAnimation.Key: NSObject]()
            expandMainAnimationDict[.target] = self.masterItem.viewController.view
            var newMainFrame = self.masterItem.viewController.view.frame
            newMainFrame.size.width = self.splitView.frame.size.width - lastInspectorWidth
            expandMainAnimationDict[.endFrame] = NSValue(rect: newMainFrame)
            var expandInspectorAnimationDict = [NSViewAnimation.Key: NSObject]()
            expandInspectorAnimationDict[.target] = self.detailItem.viewController.view
            
            var newInspectorFrame = self.detailItem.viewController.view.frame
            newInspectorFrame.size.width = lastInspectorWidth
            newInspectorFrame.origin.x = self.splitView.frame.size.width - lastInspectorWidth
            expandInspectorAnimationDict[.endFrame] = NSValue(rect: newInspectorFrame)

            let expandAnimation = NSViewAnimation(viewAnimations: [expandMainAnimationDict, expandInspectorAnimationDict])
            expandAnimation.duration = 0.25
            expandAnimation.start()
        } else {
            // Store last width so we can jump back
            lastInspectorWidth = self.detailItem.viewController.view.frame.size.width

            var collapseMainAnimationDict = [NSViewAnimation.Key: NSObject]()
            collapseMainAnimationDict[.target] = self.masterItem.viewController.view
            var newMainFrame = self.masterItem.viewController.view.frame
            newMainFrame.size.width = self.splitView.frame.size.width
            collapseMainAnimationDict[.endFrame] = NSValue(rect: newMainFrame)
            
            var collapseInspectorAnimationDict = [NSViewAnimation.Key: NSObject]()
            collapseInspectorAnimationDict[.target] = self.detailItem.viewController.view
            var newInspectorFrame = self.detailItem.viewController.view.frame
            newInspectorFrame.size.width = 0
            newInspectorFrame.origin.x = self.splitView.frame.size.width
            collapseInspectorAnimationDict[.endFrame] = NSValue(rect: newInspectorFrame)

            let collapseAnimation = NSViewAnimation(viewAnimations: [collapseMainAnimationDict, collapseInspectorAnimationDict])
            collapseAnimation.duration = 0.25
            collapseAnimation.start()
        }
    }
}
