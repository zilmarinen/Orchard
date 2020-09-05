//
//  TerrainUtilityCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 31/07/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

class TerrainUtilityCoordinator: Coordinator<TerrainUtilityViewController> {

    override init(controller: TerrainUtilityViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        guard let node = option as? SceneGraphIdentifiable, let inspector = TerrainInspector(node: node) else { return }
        
        controller.viewModel.start(inspector: inspector)
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        self.controller.viewModel.stop()
        
        completion?()
    }
}
