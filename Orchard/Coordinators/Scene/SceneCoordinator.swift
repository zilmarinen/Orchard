//
//  SceneCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa
import Meadow

class SceneCoordinator: Coordinator<SceneViewController> {
    
    override init(controller: SceneViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: SceneGraphNode?) {
        
        super.start(with: option)
        
        guard let scene = option as? Scene else { fatalError("Invalid start option") }
        
        controller.sceneView.backgroundColor = scene.backgroundColor.color
        controller.sceneView.scene = scene
        controller.sceneView.delegate = scene
        
        focus(node: scene)
    }
}

extension SceneCoordinator {
    
    override func focus(node: SceneGraphNode) {
        
        print("SceneCoordinator: focus: \(node)")
        
        guard let node = node as? SceneGraphNode else { return }
        
        var items: [NSPathControlItem] = []
        var parent: SceneGraphNode? = node
        
        while parent != nil {
            
            let item = NSPathControlItem()
            
            item.title = node.name ?? "Meadow"
            item.image = NSImage(named: "meadow_icon")
            
            items.append(item)
            
            parent = nil
        }
        
        controller.pathControl.pathItems = items.reversed()
    }
}
