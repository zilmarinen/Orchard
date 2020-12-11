//
//  FoliageUtilityTabViewCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 07/12/2020.
//

import Cocoa
import Meadow

class FoliageUtilityTabViewCoordinator: Coordinator<FoliageUtilityTabViewController> {
    
    @objc enum Tab: Int {
        
        case build
        case paint
    }
    
    lazy var buildUtilityCoordinator: FoliageBuildUtilityCoordinator = {
       
        guard let viewController = controller.children[Tab.build.rawValue] as? FoliageBuildUtilityViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = FoliageBuildUtilityCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var paintUtilityCoordinator: FoliagePaintUtilityCoordinator = {
       
        guard let viewController = controller.children[Tab.paint.rawValue] as? FoliagePaintUtilityViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = FoliagePaintUtilityCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    override init(controller: FoliageUtilityTabViewController) {
        
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

extension FoliageUtilityTabViewCoordinator {
    
    override func toggle(foliage utility: Tab) {
        
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

