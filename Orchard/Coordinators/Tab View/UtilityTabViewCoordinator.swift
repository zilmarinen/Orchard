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
     
        //TODO: Remove all below this line
        guard let option = option as? Terrain else { return }
        start(child: terrainUtilityCoordinator, with: option)
        controller.selectedTabViewItemIndex = Tab.terrain.rawValue
    }
}
