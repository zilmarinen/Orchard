//
//  SceneGraphCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa
import Meadow

class SceneGraphCoordinator: Coordinator<SceneGraphViewController> {
    
    override init(controller: SceneGraphViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: SceneGraphNode?) {
        
        super.start(with: option)
        
        guard let scene = option as? Scene else { fatalError("Invalid start option") }
        
        controller.treeController.content = scene
        
        focus(node: scene.meadow)
    }
}

extension SceneGraphCoordinator {
    
    override func focus(node: SceneGraphNode) {
        
        print("SceneGraphCoordinator: focus: \(node)")
    }
}
