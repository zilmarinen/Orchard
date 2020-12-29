//
//  MouseObservable.swift
//  Orchard
//
//  Created by Zack Brown on 11/12/2020.
//

import Cocoa

protocol MouseObservable: NSResponder {
    
    var mouseObserver: UUID? { get set }
    
    func subscribeToMouseEvents(tracksIdleEvents: Bool)
    func unsubscribeFromMouseEvents()
    
    func stateDidChange(from previousState: SceneView.MouseState?, to currentState: SceneView.MouseState)
}

extension MouseObservable {
    
    func subscribeToMouseEvents(tracksIdleEvents: Bool) {
        
        guard let sceneView = sceneView else { return }
        
        sceneView.mouseObserver.tracksIdleEvents = tracksIdleEvents
        
        mouseObserver = sceneView.mouseObserver.subscribe(stateDidChange(from:to:))
        
        print("\(self) subscribing to mouse observer")
    }
    
    func unsubscribeFromMouseEvents() {
        
        guard let sceneView = sceneView,
              let mouseObserver = mouseObserver else { return }
        
        sceneView.mouseObserver.tracksIdleEvents = false
        sceneView.mouseObserver.unsubscribe(mouseObserver)
        
        print("\(self) unsubscribing from mouse observer")
    }
}
