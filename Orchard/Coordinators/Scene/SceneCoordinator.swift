//
//  SceneCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa

class SceneCoordinator: Coordinator<SceneViewController> {
    
    override init(controller: SceneViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        let item = NSPathControlItem()
        
        item.title = "Meadow"
        item.image = NSImage(named: "meadow_icon")
        
        let item1 = NSPathControlItem()
        
        item1.title = "Meadow"
        item1.image = NSImage(named: "meadow_icon")
        
        controller.pathControl.pathItems = [item, item1]
        controller.sceneView.backgroundColor = .black
    }
}
