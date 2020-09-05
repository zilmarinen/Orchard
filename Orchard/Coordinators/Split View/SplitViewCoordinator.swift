//
//  SplitViewCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 15/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

class SplitViewCoordinator: Coordinator<SplitViewController> {
    
    lazy var sceneGraphCoordinator: SceneGraphCoordinator = {
       
        guard let viewController = controller.sceneGraphViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = SceneGraphCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var sceneViewCoordinator: SceneViewCoordinator = {
       
        guard let viewController = controller.sceneViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = SceneViewCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var sidebarCoordinator: SidebarCoordinator = {
       
        guard let viewController = controller.sidebarViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = SidebarCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    override init(controller: SplitViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        start(child: sceneGraphCoordinator, with: option)
        start(child: sceneViewCoordinator, with: option)
        start(child: sidebarCoordinator, with: option)
    }
}

extension SplitViewCoordinator {
    
    func toggle(sender: NSSegmentedControl) {
        
        let panel = (sender.selectedSegment == 0 ? SplitViewController.Panel.sceneGraph : SplitViewController.Panel.inspector)
        
        controller.toggle(panel: panel)
    }
}

extension SplitViewCoordinator: SceneGraphObserver {

    func focus(node: SceneGraphNode) {
        
        sceneGraphCoordinator.focus(node: node)
        sceneViewCoordinator.focus(node: node)
        sidebarCoordinator.focus(node: node)
    }
}
