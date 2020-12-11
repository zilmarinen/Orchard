//
//  MouseObservable.swift
//  Orchard
//
//  Created by Zack Brown on 11/12/2020.
//

import Cocoa

protocol MouseObservable: NSResponder {
    
    var mouseObserver: UUID? { get set }
    
    func subscribeToMouseEvents()
    func unsubscribeFromMouseEvents()
    
    func stateDidChange(from previousState: SceneView.MouseState?, to currentState: SceneView.MouseState)
}

extension MouseObservable {
    
    func subscribeToMouseEvents() {
        
        guard let sceneView = sceneView else { return }
        
        mouseObserver = sceneView.mouseObserver.subscribe(stateDidChange(from:to:))
        
        print("\(self) subscribing to mouse observer")
    }
    
    func unsubscribeFromMouseEvents() {
        
        guard let sceneView = sceneView,
              let mouseObserver = mouseObserver else { return }
        
        sceneView.mouseObserver.unsubscribe(mouseObserver)
        
        print("\(self) unsubscribing from mouse observer")
    }
}
