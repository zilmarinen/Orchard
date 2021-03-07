//
//  BuildingsUtilityTabViewCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 01/02/2021.
//

import Cocoa
import Meadow

class BuildingsUtilityTabViewCoordinator: Coordinator<BuildingsUtilityTabViewController> {
    
    @objc enum Tab: Int {
        
        case build
    }
    
    lazy var buildUtilityCoordinator: BuildingsBuildUtilityCoordinator = {
       
        guard let viewController = controller.children[Tab.build.rawValue] as? BuildingsBuildUtilityViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = BuildingsBuildUtilityCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    override init(controller: BuildingsUtilityTabViewController) {
        
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

extension BuildingsUtilityTabViewCoordinator {
    
    override func toggle(buildings utility: Tab) {
        
        stopChildren()
        
        switch utility {
        
        case .build:
            
            start(child: buildUtilityCoordinator, with: selectedNode)
        }
        
        controller.selectedTabViewItemIndex = utility.rawValue
    }
}
