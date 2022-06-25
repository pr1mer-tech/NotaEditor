//
//  AttributedText.swift
//  Elva
//
//  Created by Arthur Guiot on 6/24/22.
//

import Combine
import SwiftUI

struct AttributedText: NSViewRepresentable {
    let text: NSAttributedString
    let font: NSFont?    = .systemFont(ofSize: 14, weight: .regular)
    
    func makeNSView(context: Context) -> CustomTextView {
        let textView = CustomTextView(
            text: text,
            isEditable: false,
            font: font
        )
        
        return textView
    }
    
    func updateNSView(_ view: CustomTextView, context: Context) {
        view.text = text
    }
}


// MARK: - CustomTextView

final class CustomTextView: NSView {
    private var isEditable: Bool
    private var font: NSFont?
    
    weak var delegate: NSTextViewDelegate?
    
    var text: NSAttributedString {
        didSet {
            textView.textStorage?.setAttributedString(text)
        }
    }
    
    var selectedRanges: [NSValue] = [] {
        didSet {
            guard selectedRanges.count > 0 else {
                return
            }
            
            textView.selectedRanges = selectedRanges
        }
    }
    
    private lazy var scrollView: NSScrollView = {
        let scrollView = NSScrollView()
        scrollView.drawsBackground = true
        scrollView.borderType = .noBorder
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalRuler = false
        scrollView.autoresizingMask = [.width, .height]
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    class LayoutManager: NSLayoutManager {
        
        override func drawUnderline(forGlyphRange glyphRange: NSRange,
                                    underlineType underlineVal: NSUnderlineStyle,
                                    baselineOffset: CGFloat,
                                    lineFragmentRect lineRect: CGRect,
                                    lineFragmentGlyphRange lineGlyphRange: NSRange,
                                    containerOrigin: CGPoint
        ) {
            let firstPosition  = location(forGlyphAt: glyphRange.location).x
            
            let lastPosition: CGFloat
            
            if NSMaxRange(glyphRange) < NSMaxRange(lineGlyphRange) {
                lastPosition = location(forGlyphAt: NSMaxRange(glyphRange)).x
            } else {
                lastPosition = lineFragmentUsedRect(
                    forGlyphAt: NSMaxRange(glyphRange) - 1,
                    effectiveRange: nil).size.width
            }
            
            var lineRect = lineRect
            let height = lineRect.size.height * 3.5 / 4.0 // replace your under line height
            lineRect.origin.x += firstPosition
            lineRect.size.width = lastPosition - firstPosition
            lineRect.size.height = height
            
            lineRect.origin.x += containerOrigin.x
            lineRect.origin.y += containerOrigin.y
            
            lineRect = lineRect.integral.insetBy(dx: -0.5, dy: -0.5)
            
            let path = NSBezierPath(roundedRect: lineRect, xRadius: 3, yRadius: 3)
            // let path = UIBezierPath(roundedRect: lineRect, cornerRadius: 3)
            // set your cornerRadius
            path.fill()
        }
    }
    
    var layoutManager = LayoutManager()
    var textStorage = NSTextStorage()
    private lazy var textView: NSTextView = {
        let contentSize = scrollView.contentSize
        //
        let textContainer = NSTextContainer(size: scrollView.frame.size)
        textContainer.widthTracksTextView = true
        textContainer.containerSize = NSSize(
            width: contentSize.width,
            height: CGFloat.greatestFiniteMagnitude
        )
        layoutManager.replaceTextStorage(textStorage)
        textContainer.replaceLayoutManager(layoutManager)
        //
        let textView                     = NSTextView(frame: .zero, textContainer: textContainer)
        textView.autoresizingMask        = .width
        textView.backgroundColor         = NSColor.textBackgroundColor
        textView.delegate                = self.delegate
        textView.drawsBackground         = true
        textView.font                    = self.font
        textView.isEditable              = self.isEditable
        textView.isHorizontallyResizable = false
        textView.isVerticallyResizable   = true
        textView.maxSize                 = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.minSize                 = NSSize(width: 0, height: contentSize.height)
        textView.textColor               = NSColor.labelColor
        textView.allowsUndo              = true
        
        return textView
    }()
    
    // MARK: - Init
    init(text: NSAttributedString, isEditable: Bool, font: NSFont?) {
        self.font       = font
        self.isEditable = isEditable
        self.text       = text
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewWillDraw() {
        super.viewWillDraw()
        
        setupScrollViewConstraints()
        setupTextView()
    }
    
    func setupScrollViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    func setupTextView() {
        scrollView.documentView = textView
    }
}
