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
    var showDetail: Bool
    
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
        return item
    }

    init(showDetail: Bool, @ViewBuilder content: @escaping () -> TupleView<(Master, Detail)>) {
        let cv = content().value
        self.master = cv.0
        self.detail = cv.1
        self.showDetail = showDetail
    }

    // MARK: View Initialization
    func makeNSViewController(context: NSViewControllerRepresentableContext<SplitView>) -> MasterInspectorLayoutView {
        let splitViewController = MasterInspectorLayoutView()
        
        // Subviews
        splitViewController.addSplitViewItem(masterItem)
        splitViewController.addSplitViewItem(detailItem)
        
        return splitViewController
    }

    func updateNSViewController(_ splitViewController: MasterInspectorLayoutView, context: NSViewControllerRepresentableContext<SplitView>) {
        // Nothing to do here
        guard splitViewController.detailItem.isCollapsed != showDetail else { return }
        DispatchQueue.main.async {
            splitViewController.toggleSidebar(nil)
        }
    }
}
