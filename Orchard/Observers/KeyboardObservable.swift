//
//  KeyboardObservable.swift
//  Orchard
//
//  Created by Zack Brown on 11/12/2020.
//

import Cocoa

protocol KeyboardObservable: NSResponder {
    
    var keyboardObserver: UUID? { get set }
    
    func subscribeToKeyboardEvents()
    func unsubscribeFromKeyboardEvents()
    
    func stateDidChange(from previousState: SceneView.KeyboardState?, to currentState: SceneView.KeyboardState)
}

extension KeyboardObservable {
    
    func subscribeToKeyboardEvents() {
        
        guard let sceneView = sceneView else { return }
        
        keyboardObserver = sceneView.keyboardObserver.subscribe(stateDidChange(from:to:))
    }
    
    func unsubscribeFromKeyboardEvents() {
        
        guard let sceneView = sceneView,
              let keyboardObserver = keyboardObserver else { return }
        
        sceneView.keyboardObserver.unsubscribe(keyboardObserver)
    }
}
