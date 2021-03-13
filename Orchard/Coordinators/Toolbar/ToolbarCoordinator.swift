//
//  ToolbarCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa

class ToolbarCoordinator: Coordinator<ToolbarViewController> {
    
    override init(controller: ToolbarViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
