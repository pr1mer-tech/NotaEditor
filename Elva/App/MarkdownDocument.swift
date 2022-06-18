//
//  MarkdownDocument.swift
//  Elva
//
//  Created by Arthur Guiot on 6/13/22.
//

import SwiftUI

class MarkdownDocument: NSDocument {

    @State var content: String = ""

    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }
    
    // MARK: - Enablers
    
    // This enables auto save.
    override class var autosavesInPlace: Bool {
        return true
    }
    
    // This enables asynchronous-writing.
    override func canAsynchronouslyWrite(to url: URL, ofType typeName: String, for saveOperation: NSDocument.SaveOperationType) -> Bool {
        return true
    }
    
    // This enables asynchronous reading.
    override class func canConcurrentlyReadDocuments(ofType: String) -> Bool {
        return ofType == "net.daringfireball.markdown"
    }
    
    // MARK: - User Interface
    
    /// - Tag: makeWindowControllersExample
    override func makeWindowControllers() {
        // Returns the storyboard that contains your document window.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        if let windowController =
            storyboard.instantiateController(
                withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as? NSWindowController {
            addWindowController(windowController)
            
            let contentView = ContentView(content: $content, manager: DocumentStateManager())
            
            windowController.contentViewController = NSHostingController(rootView: contentView)
        }
    }
    
    // MARK: - Reading and Writing
    
    /// - Tag: readExample
    override func read(from data: Data, ofType typeName: String) throws {
        guard let str = String(data: data, encoding: .utf8) else {
            throw CocoaError(.fileReadUnknownStringEncoding)
        }
        content = str
    }
    
    /// - Tag: writeExample
    override func data(ofType typeName: String) throws -> Data {
        guard let data = content.data(using: .utf8) else {
            throw CocoaError(.fileWriteInapplicableStringEncoding)
        }
        return data
    }
    
    // MARK: - Printing
    
    func thePrintInfo() -> NSPrintInfo {
        let thePrintInfo = NSPrintInfo()
        thePrintInfo.horizontalPagination = .fit
        thePrintInfo.isHorizontallyCentered = false
        thePrintInfo.isVerticallyCentered = false
        
        // One inch margin all the way around.
        thePrintInfo.leftMargin = 72.0
        thePrintInfo.rightMargin = 72.0
        thePrintInfo.topMargin = 72.0
        thePrintInfo.bottomMargin = 72.0
        
        printInfo.dictionary().setObject(NSNumber(value: true),
                                         forKey: NSPrintInfo.AttributeKey.headerAndFooter as NSCopying)
        
        return thePrintInfo
    }
    
    @objc
    func printOperationDidRun(
        _ printOperation: NSPrintOperation, success: Bool, contextInfo: UnsafeMutableRawPointer?) {
        // Printing finished...
    }
    
    @IBAction override func printDocument(_ sender: Any?) {
        // Print the NSTextView.
        
        // Create a copy to manipulate for printing.
        let pageSize = NSSize(width: (printInfo.paperSize.width), height: (printInfo.paperSize.height))
        let textView = NSTextView(frame: NSRect(x: 0.0, y: 0.0, width: pageSize.width, height: pageSize.height))
        
        // Make sure we print on a white background.
        textView.appearance = NSAppearance(named: .aqua)
        
        // Copy the attributed string.
        textView.textStorage?.append(NSAttributedString(string: content))
        
        let printOperation = NSPrintOperation(view: textView)
        printOperation.runModal(
            for: windowControllers[0].window!,
            delegate: self,
            didRun: #selector(printOperationDidRun(_:success:contextInfo:)), contextInfo: nil)
    }
}
