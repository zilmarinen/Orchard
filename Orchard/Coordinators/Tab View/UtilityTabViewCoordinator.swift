//
//  UtilityTabViewCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 20/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

class UtilityTabViewCoordinator: Coordinator<UtilityTabViewController> {
 
    override init(controller: UtilityTabViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension UtilityTabViewCoordinator {
    
    override func didSelect(node: SceneGraphNode) {
        
        self.controller.viewModel.select(node: node)
    }
}
