//
//  OrchardCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 20/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

class OrchardCoordinator: Coordinator<OrchardViewController> {
    
    lazy var splitViewCoordinator: SplitViewCoordinator = {
       
        guard let viewController = controller.splitViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = SplitViewCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    override init(controller: OrchardViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        start(child: splitViewCoordinator, with: option)
    }
}

extension OrchardCoordinator {
    
    override func didSelect(node: SceneGraphNode) {
        
        splitViewCoordinator.sidebarCoordinator.didSelect(node: node)
        
        splitViewCoordinator.sceneGraphCoordinator.controller.outlineView.reloadItem(node, reloadChildren: true)
    }
}
