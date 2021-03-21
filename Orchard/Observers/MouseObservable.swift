//
//  MouseObservable.swift
//
//  Created by Zack Brown on 11/12/2020.
//

import Cocoa

protocol MouseObservable: NSResponder {
    
    var mouseObserver: UUID? { get set }
    
    func subscribeToMouseEvents(tracksIdleEvents: Bool)
    func unsubscribeFromMouseEvents()
    
    func stateDidChange(from previousState: SpriteView.MouseState?, to currentState: SpriteView.MouseState)
}

extension MouseObservable {
    
    func subscribeToMouseEvents(tracksIdleEvents: Bool) {
        
        guard let spriteView = spriteView else { return }
        
        spriteView.mouseObserver.tracksIdleEvents = tracksIdleEvents
        
        mouseObserver = spriteView.mouseObserver.subscribe(stateDidChange(from:to:))
        
        print("\(self) subscribing to mouse observer")
    }
    
    func unsubscribeFromMouseEvents() {
        
        guard let spriteView = spriteView,
              let mouseObserver = mouseObserver else { return }
        
        spriteView.mouseObserver.tracksIdleEvents = false
        spriteView.mouseObserver.unsubscribe(mouseObserver)
        
        print("\(self) unsubscribing from mouse observer")
    }
}
