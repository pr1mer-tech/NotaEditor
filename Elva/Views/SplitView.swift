//
//  SplitView.swift
//  Elva
//
//  Created by Arthur Guiot on 6/16/22.
//

import SwiftUI

/* The SplitView is a NSViewControllerRepresentable that binds to a NSSplitViewController.
 * It takes a ViewBuilder as an input. The first view is the master view, the second is the detail view (right sidebar).
 */
struct SplitView<Master: View, Detail: View>: NSViewControllerRepresentable {
    let master: Master
    
    var masterItem: NSSplitViewItem {
        let controller = NSHostingController(rootView: self.master)
        let item = NSSplitViewItem(viewController: controller)
        return item
    }
    
    let detail: Detail
    
    var detailItem: NSSplitViewItem {
        let controller = NSHostingController(rootView: self.detail)
        let item = NSSplitViewItem(sidebarWithViewController: controller)
        
        item.titlebarSeparatorStyle = .line
        item.allowsFullHeightLayout = true
        item.automaticMaximumThickness = 400
        item.maximumThickness = 400
        item.minimumThickness = 200
        
        return item
    }

    init(@ViewBuilder content: @escaping () -> TupleView<(Master, Detail)>) {
        let cv = content().value
        self.master = cv.0
        self.detail = cv.1
    }

    func makeNSViewController(context: NSViewControllerRepresentableContext<SplitView>) -> NSSplitViewController {
        let splitViewController = NSSplitViewController()
        splitViewController.addSplitViewItem(masterItem)
        splitViewController.addSplitViewItem(detailItem)
        
        // MARK: Styling
        splitViewController.splitView.dividerStyle = .thin
        
        return splitViewController
    }

    func updateNSViewController(_ splitViewController: NSSplitViewController, context: NSViewControllerRepresentableContext<SplitView>) {
        // Nothing to do here
    }
}
