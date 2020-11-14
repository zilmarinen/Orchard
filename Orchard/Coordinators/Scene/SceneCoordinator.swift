//
//  SceneCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa
import Meadow
import SceneKit

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
        
        controller.sceneView.backgroundColor = .systemPink//scene.backgroundColor.color
        controller.sceneView.scene = scene
        controller.sceneView.delegate = scene
        controller.sceneView.isPlaying = true
        controller.sceneView.allowsCameraControl = true
        controller.sceneView.autoenablesDefaultLighting = true
        
        focus(node: scene)
        
        scene.meadow.terrain.add(tile: .zero)
        scene.meadow.terrain.add(tile: Coordinate(x: 7, y: 0, z: 7))
        
        scene.camera.position = SCNVector3(x: 10, y: 10, z:10)
        scene.camera.look(at: scene.meadow.position)
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
