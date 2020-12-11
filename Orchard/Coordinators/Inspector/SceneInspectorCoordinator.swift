//
//  SceneInspectorCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 06/11/2020.
//

import Cocoa
import Meadow

class SceneInspectorCoordinator: Coordinator<SceneInspectorViewController>, Inspector {
    
    var inspectable: Scene? {
        
        guard let selectedNode = selectedNode else { return nil }
        
        switch Inspectable(node: selectedNode) {
        
        case .scene(let inspectable):
            
            return inspectable
            
        default: return nil
        }
    }
    
    override init(controller: SceneInspectorViewController) {
        
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

extension SceneInspectorCoordinator {
    
    func refresh() {
        
        guard controller.isViewLoaded, let inspectable = inspectable else { return }
        
        controller.sceneNameLabel.stringValue = inspectable.name ?? ""
        controller.backgroundColorWell.color = inspectable.backgroundColor.color
    }
}
