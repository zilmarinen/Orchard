//
//  SceneInspectorCoordinator.swift
//
//  Created by Zack Brown on 06/11/2020.
//

import Cocoa

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
        
        guard let spriteView = spriteView else { return }
        
        controller.sceneNameLabel.stringValue = spriteView.scene?.name ?? ""
        controller.backgroundColorWell.color = spriteView.scene?.backgroundColor ?? .white
    }
}
