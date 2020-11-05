//
//  SidebarTabViewCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 05/11/2020.
//

import Cocoa
import Meadow

class SidebarTabViewCoordinator: Coordinator<SidebarTabViewController> {
    
    @objc enum Tab: Int {
        
        case empty
        case inspector
        case utility
    }
    
    lazy var inspectorTabViewCoordinator: InspectorTabViewCoordinator = {
       
        guard let viewController = controller.children[Tab.inspector.rawValue] as? InspectorTabViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = InspectorTabViewCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var utilityTabViewCoordinator: UtilityTabViewCoordinator = {
       
        guard let viewController = controller.children[Tab.utility.rawValue] as? UtilityTabViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = UtilityTabViewCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    override init(controller: SidebarTabViewController) {
        
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

extension SidebarTabViewCoordinator {
    
    override func toggle(tab: Tab) {
        
        stopChildren()
        
        switch tab {
        
        case .inspector:
            
            start(child: inspectorTabViewCoordinator, with: selectedNode)
            
        case .utility:
            
            start(child: utilityTabViewCoordinator, with: selectedNode)
            
        default: break
        }
        
        controller.selectedTabViewItemIndex = tab.rawValue
    }
}
