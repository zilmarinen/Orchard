//
//  SceneInspectorCoordinator.swift
//
//  Created by Zack Brown on 06/11/2020.
//

import Cocoa
import Harvest

class SceneInspectorCoordinator: Coordinator<SceneInspectorViewController> {
    
    override init(controller: SceneInspectorViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        guard controller.isViewLoaded else { return }
        
        refresh()
    }
}

extension SceneInspectorCoordinator {
    
    func refresh() {
        
        guard let spriteView = spriteView,
              let scene = spriteView.scene as? Scene2D else { return }
        
        controller.sceneNameLabel.stringValue = scene.harvest.name ?? ""
        controller.sceneIdentifierLabel.stringValue = scene.harvest.identifier
    }
}
