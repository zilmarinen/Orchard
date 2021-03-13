//
//  NSResponder.swift
//  Orchard
//
//  Created by Zack Brown on 05/11/2020.
//

import Cocoa
import SpriteKit

@objc extension NSResponder {
    
    func toggle(splitView panel: SplitViewController.Panel) { responder?.toggle(splitView: panel) }
    
    func toggle(inspector: InspectorTabViewCoordinator.Tab, with object: Any? = nil) { responder?.toggle(inspector: inspector, with: object) }
    
    var responder: NSResponder? { nextResponder }
    
    var spriteView: SpriteView? { responder?.spriteView }
    
    var editor: Editor? {
    
        guard let map = spriteView?.scene as? Map else { return nil }
        
        return map.meadow
    }
}
