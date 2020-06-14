//
//  WaterInspectorCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 12/06/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

class WaterInspectorCoordinator: Coordinator<WaterInspectorViewController> {
    
    override init(controller: WaterInspectorViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        guard let node = option as? SceneGraphIdentifiable else { fatalError("Invalid start option for Water Inspector Coordinator") }
        
        self.controller.inspector = WaterInspector(node: node)
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        self.controller.inspector = nil
        
        completion?()
    }
}
