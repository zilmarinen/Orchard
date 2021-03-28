//
//  InspectorTabViewCoordinator.swift
//
//  Created by Zack Brown on 05/11/2020.
//

import Cocoa

class InspectorTabViewCoordinator: Coordinator<InspectorTabViewController> {
    
    @objc enum Tab: Int {
        
        case empty
        case actor
        case building
        case foliage
        case footpath
        case portal
        case scene
        case surface
        case water
    }
    
    lazy var actorUtilityCoordinator: ActorUtilityCoordinator = {
       
        guard let viewController = controller.children[Tab.actor.rawValue] as? ActorInspectorViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = ActorUtilityCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var buildingUtilityCoordinator: BuildingUtilityCoordinator = {
       
        guard let viewController = controller.children[Tab.building.rawValue] as? BuildingInspectorViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = BuildingUtilityCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var foliageUtilityCoordinator: FoliageUtilityCoordinator = {
       
        guard let viewController = controller.children[Tab.foliage.rawValue] as? FoliageInspectorViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = FoliageUtilityCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var footpathUtilityCoordinator: FootpathUtilityCoordinator = {
       
        guard let viewController = controller.children[Tab.footpath.rawValue] as? FootpathInspectorViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = FootpathUtilityCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var portalUtilityCoordinator: PortalUtilityCoordinator = {
       
        guard let viewController = controller.children[Tab.portal.rawValue] as? PortalInspectorViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = PortalUtilityCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var sceneInspectorCoordinator: SceneInspectorCoordinator = {
       
        guard let viewController = controller.children[Tab.scene.rawValue] as? SceneInspectorViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = SceneInspectorCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var surfaceUtilityCoordinator: SurfaceUtilityCoordinator = {
       
        guard let viewController = controller.children[Tab.surface.rawValue] as? SurfaceInspectorViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = SurfaceUtilityCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var waterUtilityCoordinator: WaterUtilityCoordinator = {
       
        guard let viewController = controller.children[Tab.water.rawValue] as? WaterInspectorViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = WaterUtilityCoordinator(controller: viewController)
        
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
        
        case .actor:
            
            guard let object = object as? ActorUtilityCoordinator.ViewState else { return }
            
            start(child: actorUtilityCoordinator, with: object)
        
        case .building:
            
            guard let object = object as? BuildingUtilityCoordinator.ViewState else { return }
            
            start(child: buildingUtilityCoordinator, with: object)
        
        case .foliage:
            
            guard let object = object as? FoliageUtilityCoordinator.ViewState else { return }
            
            start(child: foliageUtilityCoordinator, with: object)
            
        case .footpath:
            
            guard let object = object as? FootpathUtilityCoordinator.ViewState else { return }
            
            start(child: footpathUtilityCoordinator, with: object)
            
        case .portal:
            
            guard let object = object as? PortalUtilityCoordinator.ViewState else { return }
            
            start(child: portalUtilityCoordinator, with: object)
        
        case .scene:
            
            start(child: sceneInspectorCoordinator, with: nil)
            
        case .surface:
            
            guard let object = object as? SurfaceUtilityCoordinator.ViewState else { return }
            
            start(child: surfaceUtilityCoordinator, with: object)
            
        case .water:
            
            guard let object = object as? WaterUtilityCoordinator.ViewState else { return }
            
            start(child: waterUtilityCoordinator, with: object)
            
        default: break
        }
        
        controller.selectedTabViewItemIndex = inspector.rawValue
    }
}
