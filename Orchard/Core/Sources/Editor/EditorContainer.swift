//
//  EditorContainer.swift
//  Core
//
//  Created by Zack Brown on 12/07/2025.
//

import AppKit
import Base
import Container
import Harvest

open class EditorContainer<V: EditorView>: LayeredContainerViewController {
    
    public let editorView = with(V()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addSubview(editorView)
        
        editorView.pinEdges(to: view)
    }
    
    public override func viewDidLayout() {
        
        super.viewDidLayout()
        
        editorView.trackingAreas.forEach { editorView.removeTrackingArea($0) }

        editorView.addTrackingArea(.init(rect: editorView.frame,
                                         options: [.activeInKeyWindow,
                                                   .mouseMoved],
                                         owner: self))
    }
    
    public override func mouseDown(with event: NSEvent) {

        super.mouseDown(with: event)

        print("Mouse Down")
    }

    public override func mouseDragged(with event: NSEvent) {

        super.mouseDragged(with: event)

        print("Mouse Dragged")
    }

    public override func mouseUp(with event: NSEvent) {

        super.mouseUp(with: event)

        print("Mouse Up")
    }

    public override func mouseMoved(with event: NSEvent) {

        super.mouseMoved(with: event)
        
        let point = view.convert(event.locationInWindow,
                                 from: nil)
        
        cursor(hover: point)
    }

    public override func scrollWheel(with event: NSEvent) {

        super.scrollWheel(with: event)

        print("Scroll Wheel: [\(event.scrollingDeltaY)]")
    }
    
    open func cursor(down: CGPoint) {}
    open func cursor(dragged: CGPoint) {}
    open func cursor(hover: CGPoint) {}
    open func cursor(up: CGPoint) {}
}

struct CursorEvent {
    
    
}
