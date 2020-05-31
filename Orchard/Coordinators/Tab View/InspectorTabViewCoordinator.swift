//
//  InspectorTabViewCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 20/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

class InspectorTabViewCoordinator: Coordinator<InspectorTabViewController> {
 
    override init(controller: InspectorTabViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension InspectorTabViewCoordinator: SceneGraphObserver {
    
    func focus(node: SceneGraphNode) {
        
        self.controller.viewModel.select(node: node)
    }
}
