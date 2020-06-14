//
//  SceneGraphCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 20/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

class SceneGraphCoordinator: Coordinator<SceneGraphViewController> {
 
    override init(controller: SceneGraphViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        guard let meadow = option as? Meadow else { fatalError("Invalid start option for scene graph.") }
        
        super.start(with: option)
        
        controller.treeController.content = meadow
    }
}

extension SceneGraphCoordinator: SceneGraphObserver {
    
    func focus(node: SceneGraphNode) {
        print("focus")
        controller.outlineView.reloadItem(node, reloadChildren: true)
    }
}
