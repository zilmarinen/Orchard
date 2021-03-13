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
    
    func stateDidChange(from previousState: SpriteView.KeyboardState?, to currentState: SpriteView.KeyboardState)
}

extension KeyboardObservable {
    
    func subscribeToKeyboardEvents() {
        
        guard let spriteView = spriteView else { return }
        
        keyboardObserver = spriteView.keyboardObserver.subscribe(stateDidChange(from:to:))
    }
    
    func unsubscribeFromKeyboardEvents() {
        
        guard let spriteView = spriteView,
              let keyboardObserver = keyboardObserver else { return }
        
        spriteView.keyboardObserver.unsubscribe(keyboardObserver)
    }
}
