//
//  TerrainUtilityTabViewCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 05/11/2020.
//

import Cocoa
import Meadow

class TerrainUtilityTabViewCoordinator: Coordinator<TerrainUtilityTabViewController> {
    
    @objc enum Tab: Int {
        
        case build
        case paint
    }
    
    lazy var buildUtilityCoordinator: TerrainBuildUtilityCoordinator = {
       
        guard let viewController = controller.children[Tab.build.rawValue] as? TerrainBuildUtilityViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = TerrainBuildUtilityCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var paintUtilityCoordinator: TerrainPaintUtilityCoordinator = {
       
        guard let viewController = controller.children[Tab.paint.rawValue] as? TerrainPaintUtilityViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = TerrainPaintUtilityCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    override init(controller: TerrainUtilityTabViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: SceneGraphNode?) {
        
        super.start(with: option)
        
        //
    }
}

extension TerrainUtilityTabViewCoordinator {
    
    override func toggle(terrain utility: Tab) {
        
        stopChildren()
        
        switch utility {
        
        case .build:
            
            start(child: buildUtilityCoordinator, with: selectedNode)
            
        case .paint:
            
            start(child: paintUtilityCoordinator, with: selectedNode)
            
        default: break
        }
        
        controller.selectedTabViewItemIndex = utility.rawValue
    }
}
