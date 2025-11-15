//
//  EditorContainer.swift
//
//  Created by Zack Brown on 12/07/2025.
//

import AppKit
import Base
import Container
import Harvest

open class EditorContainer<V: EditorView>: LayeredContainerViewController {
    
    public let editorView = with(V(frame: .zero)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var cursorEvent: CursorEvent?
    
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
    
    // MARK: Mouse Down
    
    public override func mouseDown(with event: NSEvent) {
        
        mouseDown(locationInWindow: event.locationInWindow,
                  button: .left)
    }
    
    open override func rightMouseDown(with event: NSEvent) {
        
        mouseDown(locationInWindow: event.locationInWindow,
                  button: .right)
    }
    
    private func mouseDown(locationInWindow: CGPoint,
                           button: CursorEvent.Button) {
        
        cursorEvent = .down(location: locationInView(point: locationInWindow),
                            button: button)
        
        cursor(down: cursorEvent!)
    }
    
    // MARK: Mouse Dragged
    
    public override func mouseDragged(with event: NSEvent) {
        
        mouseDragged(locationInWindow: event.locationInWindow,
                     button: .left)
    }
    
    public override func rightMouseDragged(with event: NSEvent) {
        
        mouseDragged(locationInWindow: event.locationInWindow,
                     button: .right)
    }
    
    private func mouseDragged(locationInWindow: CGPoint,
                              button: CursorEvent.Button) {
        
        switch cursorEvent {
            
        case .down(let point, _),
             .drag(let point, _, _, _):
         
            let locationInView = locationInView(point: locationInWindow)
            
            cursorEvent = .drag(start: point,
                                location: locationInView,
                                delta: .init(x: locationInView.x - point.x,
                                             y: locationInView.y - point.y),
                                button: button)
            
            cursor(drag: cursorEvent!)
            
        default: break
        }
    }
    
    // MARK: Mouse Up
    
    public override func mouseUp(with event: NSEvent) {
        
        mouseUp(locationInWindow: event.locationInWindow,
                button: .left)
    }
    
    public override func rightMouseUp(with event: NSEvent) {
        
        mouseUp(locationInWindow: event.locationInWindow,
                button: .right)
    }
    
    private func mouseUp(locationInWindow: CGPoint,
                         button: CursorEvent.Button) {
        
        switch cursorEvent {
            
        case .down(let point, _),
             .drag(let point, _, _, _):
            
            let locationInView = locationInView(point: locationInWindow)
            
            cursorEvent = .up(start: point,
                              location: locationInView,
                              delta: .init(x: locationInView.x - point.x,
                                           y: locationInView.y - point.y),
                              button: button)
            
            cursor(up: cursorEvent!)
        
        default: break
        }
    }
    
    // MARK: Mouse Moved

    public override func mouseMoved(with event: NSEvent) {

        super.mouseMoved(with: event)
        
        cursorEvent = .hover(location: locationInView(point: event.locationInWindow))
        
        cursor(hover: cursorEvent!)
    }
    
    // MARK: Scroll

    public override func scrollWheel(with event: NSEvent) {

        super.scrollWheel(with: event)
        
        scroll(delta: .init(x: event.scrollingDeltaX,
                            y: event.scrollingDeltaY))
    }
    
    open func cursor(hover event: CursorEvent) {}
    open func cursor(down event: CursorEvent) {}
    open func cursor(drag event: CursorEvent) {}
    open func cursor(up event: CursorEvent) {}
    open func scroll(delta: CGPoint) {}
}

extension EditorContainer {
    
    private func locationInView(point: CGPoint) -> CGPoint {
        
        editorView.convert(point,
                           from: nil)
    }
}
