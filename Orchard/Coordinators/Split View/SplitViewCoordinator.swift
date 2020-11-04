//
//  SplitViewCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa

class SplitViewCoordinator: Coordinator<SplitViewController> {
    
    lazy var sceneGraphCoordinator: SceneGraphCoordinator = {
       
        guard let viewController = controller.sceneGraphViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = SceneGraphCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var sceneCoordinator: SceneCoordinator = {
       
        guard let viewController = controller.sceneViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = SceneCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var inspectorCoordinator: InspectorCoordinator = {
       
        guard let viewController = controller.inspectorViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = InspectorCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    override init(controller: SplitViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        start(child: sceneGraphCoordinator, with: option)
        start(child: sceneCoordinator, with: option)
        start(child: inspectorCoordinator, with: option)
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        stop(child: sceneGraphCoordinator)
        stop(child: sceneCoordinator)
        stop(child: inspectorCoordinator)
    }
}
