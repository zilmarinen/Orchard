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
        case terrain
    }
    
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
        
        case .terrain:
            
            start(child: terrainUtilityCoordinator, with: selectedNode)
            
        default: break
        }
        
        controller.selectedTabViewItemIndex = tab.rawValue
    }
}
