//
//  SidebarCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 20/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

class SidebarCoordinator: Coordinator<SidebarViewController> {
    
    lazy var tabViewCoordinator: SidebarTabViewCoordinator = {
        
        guard let viewController = controller.tabViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = SidebarTabViewCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    override init(controller: SidebarViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        start(child: tabViewCoordinator, with: option)
    }
}

extension SidebarCoordinator {
    
    override func toggle(tab: SidebarTabViewController.ViewState.Tab) {
        
        self.tabViewCoordinator.toggle(tab: tab)
    }
    
    override func didSelect(node: SceneGraphNode) {
        
        self.tabViewCoordinator.didSelect(node: node)
    }
}
