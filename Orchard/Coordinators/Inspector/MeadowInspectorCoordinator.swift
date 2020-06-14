//
//  MeadowInspectorCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 08/06/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

class MeadowInspectorCoordinator: Coordinator<MeadowInspectorViewController> {
    
    override init(controller: MeadowInspectorViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        guard let node = option as? SceneGraphIdentifiable else { fatalError("INvalid start option for Meadow Inspector Coordinator") }
        
        self.controller.inspector = MeadowInspector(node: node)
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        self.controller.inspector = nil
        
        completion?()
    }
}
