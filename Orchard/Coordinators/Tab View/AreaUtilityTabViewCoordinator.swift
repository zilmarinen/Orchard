//
//  AreaUtilityTabViewCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 08/12/2020.
//

import Cocoa
import Meadow

class AreaUtilityTabViewCoordinator: Coordinator<AreaUtilityTabViewController> {
    
    @objc enum Tab: Int {
        
        case build
        case paint
    }
    
    lazy var buildUtilityCoordinator: AreaBuildUtilityCoordinator = {
       
        guard let viewController = controller.children[Tab.build.rawValue] as? AreaBuildUtilityViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = AreaBuildUtilityCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var paintUtilityCoordinator: AreaPaintUtilityCoordinator = {
       
        guard let viewController = controller.children[Tab.paint.rawValue] as? AreaPaintUtilityViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = AreaPaintUtilityCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    override init(controller: AreaUtilityTabViewController) {
        
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

extension AreaUtilityTabViewCoordinator {
    
    override func toggle(area utility: Tab) {
        
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
