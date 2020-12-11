//
//  FootpathUtilityTabViewCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 03/12/2020.
//

import Cocoa
import Meadow

class FootpathUtilityTabViewCoordinator: Coordinator<FootpathUtilityTabViewController> {
    
    @objc enum Tab: Int {
        
        case build
        case paint
    }
    
    lazy var buildUtilityCoordinator: FootpathBuildUtilityCoordinator = {
       
        guard let viewController = controller.children[Tab.build.rawValue] as? FootpathBuildUtilityViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = FootpathBuildUtilityCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var paintUtilityCoordinator: FootpathPaintUtilityCoordinator = {
       
        guard let viewController = controller.children[Tab.paint.rawValue] as? FootpathPaintUtilityViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = FootpathPaintUtilityCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    override init(controller: FootpathUtilityTabViewController) {
        
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

extension FootpathUtilityTabViewCoordinator {
    
    override func toggle(footpath utility: Tab) {
        
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

