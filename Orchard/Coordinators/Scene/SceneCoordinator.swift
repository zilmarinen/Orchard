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
        
        var items: [NSPathControlItem] = []
        
        if let node = node as? (SceneGraphNode & Soilable) {
            
            var parent: (SceneGraphNode & Soilable)? = node
            
            while parent != nil {
                
                let item = NSPathControlItem()
                
                item.title = parent?.name ?? "Meadow"
                item.image = NSImage(named: "meadow_icon")
                
                items.append(item)
                
                parent = parent?.ancestor as? (SceneGraphNode & Soilable)
            }
        }
        
        guard let scene = controller.sceneView.scene as? Scene else { return }
        
        let item = NSPathControlItem()
        
        item.title = scene.name ?? "Scene"
        item.image = NSImage(named: "meadow_icon")
        
        items.append(item)
        
        controller.pathControl.pathItems = items.reversed()
    }
}
