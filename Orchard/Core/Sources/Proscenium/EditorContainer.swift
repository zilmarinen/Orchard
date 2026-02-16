//
//  EditorContainer.swift
//
//  Created by Zack Brown on 12/07/2025.
//

import AppKit
import Base
import Container
import Harvest

open class EditorContainer<V: EditorView>: NSViewController {
    
    // MARK: Gesture Recognisers
    
    private lazy var leftClickGestureRecognizer = with(NSClickGestureRecognizer(target: self,
                                                                                action: #selector(clickGestureRecognizer(_:)))) {
        
        $0.buttonMask = MouseButton.left.rawValue
    }
    
    private lazy var rightClickGestureRecognizer = with(NSClickGestureRecognizer(target: self,
                                                                                 action: #selector(clickGestureRecognizer(_:)))) {
        
        $0.buttonMask = MouseButton.right.rawValue
    }
    
    private lazy var panGestureRecognizer = with(NSPanGestureRecognizer(target: self,
                                                                        action: #selector(panGestureRecognizer(_:)))) {
        
        $0.buttonMask = MouseButton.right.rawValue
    }
    
    // MARK: Editor View
    
    public let editorView = with(V(frame: .zero)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: Children
    
    private var containerViews: [ObjectIdentifier : NSView] = [:]
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addSubview(editorView)
        
        editorView.pinEdges(to: view)
        
        editorView.gestureRecognizers = [leftClickGestureRecognizer,
                                         rightClickGestureRecognizer,
                                         panGestureRecognizer]
    }
    
    public override func viewDidLayout() {
        
        super.viewDidLayout()
        
        editorView.trackingAreas.forEach { editorView.removeTrackingArea($0) }
        
        editorView.addTrackingArea(.init(rect: editorView.frame,
                                         options: [.activeInKeyWindow,
                                                   .mouseMoved],
                                         owner: self))
    }
    
    // MARK: Containment
    
    public func insert(viewController: NSViewController) {
            
        addChild(viewController)
        
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        let objectIdentifier = ObjectIdentifier(viewController)
        
        containerViews[objectIdentifier] = viewController.view
        
        view.addSubview(viewController.view)
        
        viewController.view.pinEdges(to: view)
    }
    
    // MARK: Mouse Click Events
    
    @objc
    private func clickGestureRecognizer(_ sender: NSClickGestureRecognizer) {
        
        let button: MouseButton = sender == leftClickGestureRecognizer ? .left : .right
        
        cursor(click: button,
               location: sender.location(in: view))
    }
    
    // MARK: Mouse Pan Events
    
    @objc
    private func panGestureRecognizer(_ sender: NSPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        let location = sender.location(in: view)
        let origin =  CGPoint(x: location.x - translation.x,
                              y: location.y - translation.y)
        
        cursor(pan: .left,
               location: origin,
               translation: translation)
    }
    
    // MARK: Key Pressed
    
    public override func keyDown(with event: NSEvent) {
        
        guard let keyCode = NSEvent.KeyCode(rawValue: Int(event.keyCode)) else { return }
        
        key(down: keyCode)
    }
    
    // MARK: Mouse Moved

    public override func mouseMoved(with event: NSEvent) {

        super.mouseMoved(with: event)
        
        cursor(hover: locationInView(point: event.locationInWindow))
    }
    
    // MARK: Scroll

    public override func scrollWheel(with event: NSEvent) {

        super.scrollWheel(with: event)
        
        cursor(magnify: event.scrollingDeltaY)
    }
    
    // MARK: Open Methods
    
    open func key(down keyCode: NSEvent.KeyCode) {}
    open func cursor(click button: MouseButton,
                     location: CGPoint) {}
    open func cursor(hover location: CGPoint) {}
    open func cursor(magnify magnification: Double) {}
    open func cursor(pan button: MouseButton,
                     location: CGPoint,
                     translation: CGPoint) {}
}

extension EditorContainer {
    
    private func locationInView(point: CGPoint) -> CGPoint {
        
        editorView.convert(point,
                           from: nil)
    }
}
