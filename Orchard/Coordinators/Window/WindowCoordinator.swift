//
//  WindowCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa
import Meadow

class WindowCoordinator: Coordinator<WindowController> {
    
    lazy var splitViewCoordinator: SplitViewCoordinator = {
        
        guard let viewController = controller.splitViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = SplitViewCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    override init(controller: WindowController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: SceneGraphNode?) {
        
        super.start(with: option)
        
        let scene = (option as? Scene) ?? Scene(season: .spring)
        
        if option == nil {
            
            let flag = false
            
            if flag {
                
                _ = scene.meadow.terrain.add(tile: .zero) { tile in

                    tile.tileType = .sand
                }
                _ = scene.meadow.terrain.add(tile: .forward)
                _ = scene.meadow.terrain.add(tile: .left)
                _ = scene.meadow.terrain.add(tile: .backward)
                _ = scene.meadow.terrain.add(tile: .right)

                _ = scene.meadow.terrain.add(tile: Coordinate(x: 1, y: 0, z: 1))
                _ = scene.meadow.terrain.add(tile: Coordinate(x: 1, y: 0, z: -1))
                _ = scene.meadow.terrain.add(tile: Coordinate(x: -1, y: 0, z: 1))
                _ = scene.meadow.terrain.add(tile: Coordinate(x: -1, y: 0, z: -1))

                _ = scene.meadow.terrain.add(tile: Coordinate(x: 0, y: 0, z: 3))
                _ = scene.meadow.terrain.add(tile: Coordinate(x: 0, y: 0, z: 4))
            }
            else {
                
                _ = scene.meadow.area.add(tile: .zero) { tile in
                
                    tile.tileType = .dirt
                }
                _ = scene.meadow.area.add(tile: .forward)
                _ = scene.meadow.area.add(tile: .left)
                _ = scene.meadow.area.add(tile: .backward)
                _ = scene.meadow.area.add(tile: .right)
                
                _ = scene.meadow.area.add(tile: Coordinate(x: 1, y: 0, z: 1))
                _ = scene.meadow.area.add(tile: Coordinate(x: 1, y: 0, z: -1))
                _ = scene.meadow.area.add(tile: Coordinate(x: -1, y: 0, z: 1))
                _ = scene.meadow.area.add(tile: Coordinate(x: -1, y: 0, z: -1))
                
                _ = scene.meadow.area.add(tile: Coordinate(x: 0, y: 0, z: 3))
                _ = scene.meadow.area.add(tile: Coordinate(x: 0, y: 0, z: 4))
            }
        }
        
        start(child: splitViewCoordinator, with: scene)
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        stop(child: splitViewCoordinator)
    }
}

extension WindowCoordinator {
    
    override func toggle(splitView panel: SplitViewController.Panel) {
     
        splitViewCoordinator.controller.toggle(splitView: panel)
    }
}
