//
//  MasterInspectorLayoutView.swift
//  Nota
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        detailItem.titlebarSeparatorStyle = .shadow
        detailItem.allowsFullHeightLayout = true
        
        // Subviews
        self.addSplitViewItem(masterItem)
        self.addSplitViewItem(detailItem)

        // Constraints
        detailItem.viewController.view.widthAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
        detailItem.viewController.view.widthAnchor.constraint(lessThanOrEqualToConstant: 350).isActive = true
    }
    
    override func splitView(_ splitView: NSSplitView, canCollapseSubview subview: NSView) -> Bool {
        return false
    }
}
