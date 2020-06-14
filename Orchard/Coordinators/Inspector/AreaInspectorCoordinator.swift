//
//  AreaInspectorCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 12/06/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

class AreaInspectorCoordinator: Coordinator<AreaInspectorViewController> {
    
    override init(controller: AreaInspectorViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        guard let node = option as? SceneGraphIdentifiable else { fatalError("Invalid start option for Area Inspector Coordinator") }
        
        self.controller.inspector = AreaInspector(node: node)
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        self.controller.inspector = nil
        
        completion?()
    }
}
