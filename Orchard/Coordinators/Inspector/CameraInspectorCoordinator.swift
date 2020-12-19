//
//  CameraInspectorCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 07/11/2020.
//

import Cocoa
import Meadow

class CameraInspectorCoordinator: Coordinator<CameraInspectorViewController>, Inspector {
    
    var inspectable: Camera? {
        
        guard let selectedNode = selectedNode else { return nil }
        
        switch Inspectable(node: selectedNode) {
        
        case .camera(let inspectable):
            
            return inspectable
            
        default: return nil
        }
    }
    
    override init(controller: CameraInspectorViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: SceneGraphNode?) {
        
        super.start(with: option)
        
        refresh()
    }
}

extension CameraInspectorCoordinator {
    
    func refresh() {
        
        guard controller.isViewLoaded, let inspectable = inspectable else { return }
        
        controller.orthographicProjectionButton.state = (inspectable.jig.camera?.usesOrthographicProjection ?? false ? .on : .off)
    }
}
