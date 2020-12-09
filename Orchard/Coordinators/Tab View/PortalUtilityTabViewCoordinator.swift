//
//  PortalUtilityTabViewCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 09/12/2020.
//

import Cocoa
import Meadow

class PortalUtilityTabViewCoordinator: Coordinator<PortalUtilityTabViewController> {
    
    @objc enum Tab: Int {
        
        case build
    }
    
    lazy var buildUtilityCoordinator: PortalBuildUtilityCoordinator = {
       
        guard let viewController = controller.children[Tab.build.rawValue] as? PortalBuildUtilityViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = PortalBuildUtilityCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    override init(controller: PortalUtilityTabViewController) {
        
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

extension PortalUtilityTabViewCoordinator {
    
    override func toggle(portals utility: Tab) {
        
        stopChildren()
        
        switch utility {
        
        case .build:
            
            start(child: buildUtilityCoordinator, with: selectedNode)
            
        default: break
        }
        
        controller.selectedTabViewItemIndex = utility.rawValue
    }
}

