//
//  NSResponder.swift
//
//  Created by Zack Brown on 05/11/2020.
//

import Cocoa
import Harvest
import Meadow
import SpriteKit

@objc extension NSResponder {
    
    func toggle(splitView panel: SplitViewController.Panel) { responder?.toggle(splitView: panel) }
    
    func toggle(editor: SceneCoordinator.ViewState) { responder?.toggle(editor: editor) }
    func toggle(inspector: InspectorTabViewCoordinator.Tab, with object: Any? = nil) { responder?.toggle(inspector: inspector, with: object) }
    
    var responder: NSResponder? { nextResponder }
    
    var sceneView: SceneView? { responder?.sceneView }
    var spriteView: SpriteView? { responder?.spriteView }
    
    var editor: Scene2D? {
    
        guard let map = spriteView?.scene as? Scene2D else { return nil }
        
        return map
    }
    
    func export() throws { try responder?.export() }
}
