//
//  SidebarTabViewCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 20/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

class SidebarTabViewCoordinator: Coordinator<SidebarTabViewController> {
    
    lazy var inspectorTabViewCoordinator: InspectorTabViewCoordinator = {
       
        guard let viewController = controller.inspectorTabViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = InspectorTabViewCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var utilityTabViewCoordinator: UtilityTabViewCoordinator = {
       
        guard let viewController = controller.utilityTabViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = UtilityTabViewCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    override init(controller: SidebarTabViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        start(child: inspectorTabViewCoordinator, with: option)
        start(child: utilityTabViewCoordinator, with: option)
    }
}

extension SidebarTabViewCoordinator {
    
    override func toggle(tab: SidebarTabViewController.ViewState.Tab) {
        
        self.controller.viewModel.toggle(tab: tab)
    }
    
    override func didSelect(node: SceneGraphNode) {
        
        guard let node = node as? SceneGraphIdentifiable else { return }
        
        self.controller.viewModel.select(node: node)
    }
}
