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
    
    lazy var tabViewCoordinator: TerrainUtilityTabViewCoordinator = {
        
        guard let viewController = controller.tabViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = TerrainUtilityTabViewCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()

    override init(controller: TerrainUtilityViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        print("start: TerrainUtilityCoordinator")
        start(child: tabViewCoordinator, with: option)
        
        guard let node = option as? SceneGraphIdentifiable else { return }
        
        controller.inspector = TerrainInspector(node: node)
    }
}
