//
//  PortalBuildUtilityCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 09/12/2020.
//

import Cocoa
import Meadow

class PortalBuildUtilityCoordinator: Coordinator<PortalBuildUtilityViewController> {
    
    override init(controller: PortalBuildUtilityViewController) {
        
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
