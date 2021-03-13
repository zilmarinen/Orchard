//
//  SceneCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa
import Meadow
import SpriteKit

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
        
        guard let spriteView = spriteView else { return }
        
        if let scene = option as? Map {
            
            scene.isPaused = false
            scene.backgroundColor = .white
            scene.anchorPoint = .init(x: 0.5, y: 0.5)
            scene.scaleMode = .aspectFill
            
            spriteView.presentScene(scene)
        }
        
        if spriteView.scene == nil {
        
            let scene = Map()
        
            scene.isPaused = false
            scene.backgroundColor = .white
            scene.anchorPoint = .init(x: 0.5, y: 0.5)
            scene.scaleMode = .aspectFill
        
            spriteView.presentScene(scene)
            
            _ = scene.meadow.surface.add(tile: .zero)
            _ = scene.meadow.surface.add(tile: Coordinate(x: 1, y: 0, z: 0))
            _ = scene.meadow.surface.add(tile: Coordinate(x: -1, y: 0, z: 0))
            _ = scene.meadow.surface.add(tile: Coordinate(x: 0, y: 0, z: 1))
            _ = scene.meadow.surface.add(tile: Coordinate(x: 0, y: 0, z: -1))
        }
    }
}
