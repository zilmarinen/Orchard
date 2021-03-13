//
//  InspectorTabViewCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 05/11/2020.
//

import Cocoa

class InspectorTabViewCoordinator: Coordinator<InspectorTabViewController> {
    
    @objc enum Tab: Int {
        
        case empty
        case scene
        case surface
    }
    
    lazy var surfaceUtilityCoordinator: SurfaceUtilityCoordinator = {
       
        guard let viewController = controller.children[Tab.surface.rawValue] as? SurfaceInspectorViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = SurfaceUtilityCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var sceneInspectorCoordinator: SceneInspectorCoordinator = {
       
        guard let viewController = controller.children[Tab.scene.rawValue] as? SceneInspectorViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = SceneInspectorCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    override init(controller: InspectorTabViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        //
    }
}

extension InspectorTabViewCoordinator {
    
    override func toggle(inspector: Tab, with object: Any? = nil) {
        
        stopChildren()
        
        switch inspector {
        
        case .scene:
            
            start(child: sceneInspectorCoordinator, with: nil)
            
        case .surface:
            
            guard let object = object as? SurfaceUtilityCoordinator.ViewState else { return }
            
            start(child: surfaceUtilityCoordinator, with: object)
            
        default: break
        }
        
        controller.selectedTabViewItemIndex = inspector.rawValue
    }
}
