//
//  OutlineView.swift
//
//  Created by Zack Brown on 05/08/2025.
//

import AppKit

internal protocol OutlineViewMenuDelegate: AnyObject {
    
    func outlineView(_ outlineView: OutlineView,
                     menuFor row: Int) -> NSMenu?
}

internal class OutlineView: NSOutlineView {
    
    private var contextualRect = NSRect.zero
    
    private weak var eventHandler: OutlineViewMenuDelegate?
    
    init(eventHandler: OutlineViewMenuDelegate) {
        
        self.eventHandler = eventHandler
        
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func draw(_ dirtyRect: NSRect) {
        
        super.draw(dirtyRect)
        
        guard !contextualRect.isEmpty else { return }
        
        let path = NSBezierPath(rect: contextualRect)
        let fillColor = NSColor.keyboardFocusIndicatorColor
        
        fillColor.set()
        path.stroke()
    }
    
    override func mouseDown(with event: NSEvent) {
        
        super.mouseDown(with: event)
        
        guard !contextualRect.isEmpty else { return }
        
        contextualRect = .zero
        
        setNeedsDisplay(contextualRect)
    }
    
    override func didCloseMenu(_ menu: NSMenu,
                               with event: NSEvent?) {
        
        super.didCloseMenu(menu,
                           with: event)
        
        guard !contextualRect.isEmpty else { return }
        
        contextualRect = .zero
        
        setNeedsDisplay(bounds)
    }
    
    override func menu(for event: NSEvent) -> NSMenu? {
        
        contextualRect = .zero
        
        let point = convert(event.locationInWindow, from: nil)
        let row = row(at: point)
        
        if row != -1 {
            
            contextualRect = frameOfCell(atColumn: 0,
                                         row: row)
            
            let frame = frameOfCell(atColumn: 0,
                                    row: selectedRow)
            
            if contextualRect.intersects(frame) {
                
                contextualRect = .zero
            }
        }
        
        setNeedsDisplay(contextualRect)
        
        guard !contextualRect.isEmpty else {
            
            return eventHandler?.outlineView(self,
                                             menuFor: selectedRow)
        }
        
        return eventHandler?.outlineView(self,
                                         menuFor: row)
    }
}
