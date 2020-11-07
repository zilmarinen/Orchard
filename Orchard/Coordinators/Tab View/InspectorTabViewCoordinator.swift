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
        case scene
        case terrain
    }
    
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
        
        case .scene:
            
            start(child: sceneInspectorCoordinator, with: selectedNode)
            
        case .terrain:
            
            start(child: terrainInspectorCoordinator, with: selectedNode)
            
        default: break
        }
        
        controller.selectedTabViewItemIndex = tab.rawValue
    }
}
