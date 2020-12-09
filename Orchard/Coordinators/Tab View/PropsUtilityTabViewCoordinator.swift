//
//  PropsUtilityTabViewCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 08/12/2020.
//

import Cocoa
import Meadow

class PropsUtilityTabViewCoordinator: Coordinator<PropsUtilityTabViewController> {
    
    @objc enum Tab: Int {
        
        case build
        case paint
    }
    
    lazy var buildUtilityCoordinator: PropsBuildUtilityCoordinator = {
       
        guard let viewController = controller.children[Tab.build.rawValue] as? PropsBuildUtilityViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = PropsBuildUtilityCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var paintUtilityCoordinator: PropsPaintUtilityCoordinator = {
       
        guard let viewController = controller.children[Tab.paint.rawValue] as? PropsPaintUtilityViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = PropsPaintUtilityCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    override init(controller: PropsUtilityTabViewController) {
        
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

extension PropsUtilityTabViewCoordinator {
    
    override func toggle(props utility: Tab) {
        
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

