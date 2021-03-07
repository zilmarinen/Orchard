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
        
        start(child: splitViewCoordinator, with: scene)
        
        if option == nil {
            
            setupDefault(scene: scene)
        }
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

extension WindowCoordinator {
    
    func setupDefault(scene: Scene) {
        
        let coordinates: [Coordinate] = [.zero,
                                         .forward,
                                         .left,
                                         .backward,
                                         .right,
                                         .forward + .left,
                                         .forward + .right,
                                         .backward + .left,
                                         .backward + .right]
        
        for coordinate in coordinates {
            
            _ = scene.meadow.terrain.add(tile: coordinate)
        }
    }
}
