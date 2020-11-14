//
//  CameraInspectorCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 07/11/2020.
//

import Cocoa
import Meadow

class CameraInspectorCoordinator: Coordinator<CameraInspectorViewController> {
    
    override init(controller: CameraInspectorViewController) {
        
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
