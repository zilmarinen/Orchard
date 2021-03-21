//
//  SplitViewCoordinator.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa
import Meadow
import SpriteKit

class SplitViewCoordinator: Coordinator<SplitViewController> {
    
    lazy var toolbarCoordinator: ToolbarCoordinator = {
       
        guard let viewController = controller.toolbarViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = ToolbarCoordinator(controller: viewController)
        
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
        
        start(child: toolbarCoordinator, with: option)
        start(child: sceneCoordinator, with: option)
        start(child: inspectorCoordinator, with: option)
    }
}

extension SplitViewCoordinator {
    
    override var sceneView: SceneView? { sceneCoordinator.controller.scnView }
    override var spriteView: SpriteView? { sceneCoordinator.controller.skView }
    
    override func toggle(inspector: InspectorTabViewCoordinator.Tab, with object: Any? = nil) {
        
        inspectorCoordinator.tabViewCoordinator.toggle(inspector: inspector, with: object)
        toolbarCoordinator.controller.toggle(inspector: inspector)
    }
}
