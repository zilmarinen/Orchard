//
//  SpriteView.swift
//
//  Created by Zack Brown on 11/12/2020.
//

import SpriteKit

class SpriteView: SKView {
    
    public lazy var keyboardObserver: KeyboardObserver = {
           
        return KeyboardObserver(initialState: .idle)
    }()
    
    public lazy var mouseObserver: MouseObserver = {
       
        return MouseObserver(initialState: .idle(position: .zero))
    }()

    public override func updateTrackingAreas() {
        
        super.updateTrackingAreas()
        
        let trackingArea = NSTrackingArea(rect: bounds, options: [NSTrackingArea.Options.mouseMoved, NSTrackingArea.Options.activeInKeyWindow], owner: self, userInfo: nil)
        
        addTrackingArea(trackingArea)
    }
}

extension SpriteView {
    
    public override func flagsChanged(with event: NSEvent) {
        
        super.flagsChanged(with: event)
        
        guard let keyCode = SpriteView.KeyboardState.KeyCode(rawValue: event.keyCode) else { return }
        
        switch keyboardObserver.state {
            
        case .idle:
            
            keyboardObserver.state = .keyDown(key: keyCode)
            
        case .keysHeld(let keys):
            
            if !keys.contains(keyCode) {
            
                keyboardObserver.state = .keyDown(key: keyCode)
            }
            else {
                
                keyboardObserver.state = .keyUp(key: keyCode)
            }
            
        default: break
        }
    }
    
    public override func keyDown(with event: NSEvent) {
        
        super.keyDown(with: event)
        
        guard let keyCode = SpriteView.KeyboardState.KeyCode(rawValue: event.keyCode) else { return }
        
        switch keyboardObserver.state {
            
        case .idle:
            
            keyboardObserver.state = .keyDown(key: keyCode)
            
        case .keysHeld(let keys):
            
            guard !keys.contains(keyCode) else { break }
            
            keyboardObserver.state = .keyDown(key: keyCode)
            
        default: break
        }
    }
    
    public override func keyUp(with event: NSEvent) {
        
        super.keyUp(with: event)
        
        guard let keyCode = SpriteView.KeyboardState.KeyCode(rawValue: event.keyCode) else { return }
        
        keyboardObserver.state = .keyUp(key: keyCode)
    }
}

extension SpriteView {
    
    public override func mouseDown(with event: NSEvent) {
        
        super.mouseDown(with: event)
        
        mouseDown(event: event, clickType: .left)
    }
    
    public override func rightMouseDown(with event: NSEvent) {
        
        super.rightMouseDown(with: event)
        
        mouseDown(event: event, clickType: .right)
    }
    
    public override func mouseUp(with event: NSEvent) {
        
        super.mouseUp(with: event)
        
        mouseUp(event: event, clickType: .left)
    }
    
    public override func rightMouseUp(with event: NSEvent) {
        
        super.rightMouseUp(with: event)
        
        mouseUp(event: event, clickType: .right)
    }
    
    public override func mouseDragged(with event: NSEvent) {
        
        super.mouseDragged(with: event)
        
        mouseDragged(event: event, clickType: .left)
    }
    
    public override func rightMouseDragged(with event: NSEvent) {
        
        super.rightMouseDragged(with: event)
        
        mouseDragged(event: event, clickType: .right)
    }
    
    public override func mouseMoved(with event: NSEvent) {
        
        super.mouseMoved(with: event)
        
        guard mouseObserver.tracksIdleEvents else { return }
        
        switch mouseObserver.state {
            
        case .idle:
            
            let point = convert(event.locationInWindow, from: nil)
            
            mouseObserver.state = .idle(position: point)
            
        default: break
        }
    }
    
    override func magnify(with event: NSEvent) {
        
        super.magnify(with: event)
        
        mouseZoom(event: event)
    }
}

extension SpriteView {
    
    func mouseDown(event: NSEvent, clickType: SpriteView.MouseState.ClickType) {
        
        switch mouseObserver.state {
            
        case .idle:
            
            let point = convert(event.locationInWindow, from: nil)
            
            mouseObserver.state = .down(position: SpriteView.MouseState.Click(start: point, end: point), clickType: clickType)
            
        default: break
        }
    }
    
    func mouseUp(event: NSEvent, clickType: SpriteView.MouseState.ClickType) {
     
        switch mouseObserver.state {
            
        case .down(let position, _),
             .tracking(let position, _):
            
            let point = convert(event.locationInWindow, from: nil)
            
            mouseObserver.state = .up(position: SpriteView.MouseState.Click(start: position.start, end: point), clickType: clickType)
            
        default: break
        }
    }
    
    func mouseDragged(event: NSEvent, clickType: SpriteView.MouseState.ClickType) {
        
        switch mouseObserver.state {
            
        case .down(let position, _),
             .tracking(let position, _):
            
            let point = convert(event.locationInWindow, from: nil)
            
            mouseObserver.state = .tracking(position: SpriteView.MouseState.Click(start: position.start, end: point), clickType: clickType)
            
        default: break
        }
    }
    
    func mouseZoom(event: NSEvent) {
        
        switch mouseObserver.state {
        
        case .idle:
            
            let point = convert(event.locationInWindow, from: nil)
            
            mouseObserver.state = .zoom(position: point, delta: Double(event.magnification))
            
        default: break
        }
    }
}
