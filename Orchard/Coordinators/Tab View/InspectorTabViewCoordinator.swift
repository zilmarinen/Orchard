//
//  InspectorTabViewCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 05/11/2020.
//

import Cocoa
import Meadow

class InspectorTabViewCoordinator: Coordinator<InspectorTabViewController> {
    
    @objc enum Tab: Int {
        
        case empty
        case area
        case buildings
        case camera
        case foliage
        case footpath
        case portals
        case props
        case scene
        case terrain
    }
    
    lazy var areaInspectorCoordinator: AreaInspectorCoordinator = {
       
        guard let viewController = controller.children[Tab.area.rawValue] as? AreaInspectorViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = AreaInspectorCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var buildingInspectorCoordinator: BuildingInspectorCoordinator = {
       
        guard let viewController = controller.children[Tab.buildings.rawValue] as? BuildingInspectorViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = BuildingInspectorCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var cameraInspectorCoordinator: CameraInspectorCoordinator = {
       
        guard let viewController = controller.children[Tab.camera.rawValue] as? CameraInspectorViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = CameraInspectorCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var foliageInspectorCoordinator: FoliageInspectorCoordinator = {
       
        guard let viewController = controller.children[Tab.foliage.rawValue] as? FoliageInspectorViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = FoliageInspectorCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var footpathInspectorCoordinator: FootpathInspectorCoordinator = {
       
        guard let viewController = controller.children[Tab.footpath.rawValue] as? FootpathInspectorViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = FootpathInspectorCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var portalInspectorCoordinator: PortalInspectorCoordinator = {
       
        guard let viewController = controller.children[Tab.portals.rawValue] as? PortalInspectorViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = PortalInspectorCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var propInspectorCoordinator: PropsInspectorCoordinator = {
       
        guard let viewController = controller.children[Tab.props.rawValue] as? PropsInspectorViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = PropsInspectorCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var sceneInspectorCoordinator: SceneInspectorCoordinator = {
       
        guard let viewController = controller.children[Tab.scene.rawValue] as? SceneInspectorViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = SceneInspectorCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var terrainInspectorCoordinator: TerrainInspectorCoordinator = {
       
        guard let viewController = controller.children[Tab.terrain.rawValue] as? TerrainInspectorViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = TerrainInspectorCoordinator(controller: viewController)
        
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
    
    override func start(with option: SceneGraphNode?) {
        
        super.start(with: option)
        
        guard let category = option?.category else { return }
        
        switch SceneGraphCategory(rawValue: category) {
        
        case .area,
             .areaChunk,
             .areaTile:
            
            toggle(inspector: .area)
            
        case .buildings,
             .buildingChunk,
             .buildingTile,
             .buildingLayer:
            
            toggle(inspector: .buildings)
        
        case .camera:
            
            toggle(inspector: .camera)
            
        case .foliage,
             .foliageChunk,
             .foliageTile:
            
            toggle(inspector: .foliage)
        
        case .footpath,
             .footpathChunk,
             .footpathTile:
            
            toggle(inspector: .footpath)
            
        case .portals,
             .portal:
            
            toggle(inspector: .portals)
            
        case .props,
             .prop:
            
            toggle(inspector: .props)
            
        case .scene:
            
            toggle(inspector: .scene)
            
        case .terrain,
             .terrainChunk,
             .terrainTile:
            
            toggle(inspector: .terrain)
            
        default:
            
            toggle(inspector: .empty)
        }
    }
}

extension InspectorTabViewCoordinator {
    
    override func toggle(inspector tab: Tab) {
        
        stopChildren()
        
        switch tab {
        
        case .area:
            
            start(child: areaInspectorCoordinator, with: selectedNode)
            
        case .buildings:
            
            start(child: buildingInspectorCoordinator, with: selectedNode)
        
        case .camera:
            
            start(child: cameraInspectorCoordinator, with: selectedNode)
            
        case .foliage:
            
            start(child: foliageInspectorCoordinator, with: selectedNode)
            
        case .footpath:
            
            start(child: footpathInspectorCoordinator, with: selectedNode)
            
        case .portals:
            
            start(child: portalInspectorCoordinator, with: selectedNode)
            
        case .props:
            
            start(child: propInspectorCoordinator, with: selectedNode)
        
        case .scene:
            
            start(child: sceneInspectorCoordinator, with: selectedNode)
            
        case .terrain:
            
            start(child: terrainInspectorCoordinator, with: selectedNode)
            
        default: break
        }
        
        controller.selectedTabViewItemIndex = tab.rawValue
    }
}
