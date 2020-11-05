//
//  TerrainUtilityTabViewCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 05/11/2020.
//

import Cocoa
import Meadow

class TerrainUtilityTabViewCoordinator: Coordinator<TerrainUtilityTabViewController> {
    
    override init(controller: TerrainUtilityTabViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: SceneGraphNode?) {
        
        super.start(with: option)
        
        //
    }
}
