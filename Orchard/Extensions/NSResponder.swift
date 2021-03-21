//
//  NSResponder.swift
//
//  Created by Zack Brown on 05/11/2020.
//

import Cocoa
import Meadow
import SpriteKit

@objc extension NSResponder {
    
    func toggle(splitView panel: SplitViewController.Panel) { responder?.toggle(splitView: panel) }
    
    func toggle(editor: SceneCoordinator.ViewState) { responder?.toggle(editor: editor) }
    func toggle(inspector: InspectorTabViewCoordinator.Tab, with object: Any? = nil) { responder?.toggle(inspector: inspector, with: object) }
    
    var responder: NSResponder? { nextResponder }
    
    var sceneView: SceneView? { responder?.sceneView }
    var spriteView: SpriteView? { responder?.spriteView }
    
    var editor: Editor? {
    
        guard let map = spriteView?.scene as? Map else { return nil }
        
        return map.meadow
    }
}

protocol Responder2D: Soilable {
    
    var responder: Responder2D? { get }
    
    var map: Map? { get }
}

extension Responder2D {
    
    var responder: Responder2D? { ancestor as? Responder2D }
    
    var map: Map? { responder?.map }
}
