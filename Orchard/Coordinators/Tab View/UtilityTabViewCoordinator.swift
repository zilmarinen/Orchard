//
//  UtilityTabViewCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 05/11/2020.
//

import Cocoa
import Meadow

class UtilityTabViewCoordinator: Coordinator<UtilityTabViewController> {
    
    @objc enum Tab: Int {
        
        case empty
        case area
        case buildings
        case foliage
        case footpath
        case portals
        case props
        case terrain
    }
    
    lazy var areaUtilityCoordinator: AreaUtilityCoordinator = {
       
        guard let viewController = controller.children[Tab.area.rawValue] as? AreaUtilityViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = AreaUtilityCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var buildingsUtilityCoordinator: BuildingsUtilityCoordinator = {
       
        guard let viewController = controller.children[Tab.buildings.rawValue] as? BuildingsUtilityViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = BuildingsUtilityCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var foliageUtilityCoordinator: FoliageUtilityCoordinator = {
       
        guard let viewController = controller.children[Tab.foliage.rawValue] as? FoliageUtilityViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = FoliageUtilityCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var footpathUtilityCoordinator: FootpathUtilityCoordinator = {
       
        guard let viewController = controller.children[Tab.footpath.rawValue] as? FootpathUtilityViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = FootpathUtilityCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var portalUtilityCoordinator: PortalUtilityCoordinator = {
       
        guard let viewController = controller.children[Tab.portals.rawValue] as? PortalUtilityViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = PortalUtilityCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var propsUtilityCoordinator: PropsUtilityCoordinator = {
       
        guard let viewController = controller.children[Tab.props.rawValue] as? PropsUtilityViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = PropsUtilityCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var terrainUtilityCoordinator: TerrainUtilityCoordinator = {
       
        guard let viewController = controller.children[Tab.terrain.rawValue] as? TerrainUtilityViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = TerrainUtilityCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    override init(controller: UtilityTabViewController) {
        
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
            
            start(child: areaUtilityCoordinator, with: option)
            
            controller.selectedTabViewItemIndex = Tab.area.rawValue
            
        case .buildings,
             .buildingChunk,
             .buildingTile,
             .buildingLayer:
            
            start(child: buildingsUtilityCoordinator, with: option)
            
            controller.selectedTabViewItemIndex = Tab.buildings.rawValue
            
        case .foliage,
             .foliageChunk,
             .foliageTile:
            
            start(child: foliageUtilityCoordinator, with: option)
            
            controller.selectedTabViewItemIndex = Tab.foliage.rawValue
        
        case .footpath,
             .footpathChunk,
             .footpathTile:
            
            start(child: footpathUtilityCoordinator, with: option)
            
            controller.selectedTabViewItemIndex = Tab.footpath.rawValue
            
        case .portals,
             .portal:
            
            start(child: portalUtilityCoordinator, with: option)
            
            controller.selectedTabViewItemIndex = Tab.portals.rawValue
            
        case .props,
             .prop:
            
            start(child: propsUtilityCoordinator, with: option)
            
            controller.selectedTabViewItemIndex = Tab.props.rawValue
        
        case .terrain,
             .terrainChunk,
             .terrainTile:
            
            start(child: terrainUtilityCoordinator, with: option)
            
            controller.selectedTabViewItemIndex = Tab.terrain.rawValue
            
        default:
            
            controller.selectedTabViewItemIndex = Tab.empty.rawValue
        }
    }
}

extension UtilityTabViewCoordinator {
    
    override func toggle(utility tab: Tab) {
        
        stopChildren()
        
        switch tab {
        
        case .area:
            
            start(child: areaUtilityCoordinator, with: selectedNode)
            
        case .buildings:
            
            start(child: buildingsUtilityCoordinator, with: selectedNode)
            
        case .foliage:
            
            start(child: foliageUtilityCoordinator, with: selectedNode)
        
        case .footpath:
            
            start(child: footpathUtilityCoordinator, with: selectedNode)
            
        case .portals:
            
            start(child: portalUtilityCoordinator, with: selectedNode)
            
        case .props:
            
            start(child: propsUtilityCoordinator, with: selectedNode)
        
        case .terrain:
            
            start(child: terrainUtilityCoordinator, with: selectedNode)
            
        default: break
        }
        
        controller.selectedTabViewItemIndex = tab.rawValue
    }
}
