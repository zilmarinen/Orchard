//
//  WindowCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 13/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

class WindowCoordinator: Coordinator<OrchardWindowController> {
    
    lazy var orchardCoordinator: OrchardCoordinator = {
        
        guard let viewController = controller.contentViewController as? OrchardViewController else { fatalError("Invalid view controller hierarchy") }
       
        let coordinator = OrchardCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    weak var meadow: Meadow?
    
    override init(controller: OrchardWindowController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        guard let meadow = option as? Meadow else { fatalError("Invalid start option for window.") }
        
        self.meadow = meadow
        
        super.start(with: option)
        
        start(child: orchardCoordinator, with: option)
        
        if let screen = controller.window?.screen {
        
            controller.window?.setFrame(screen.visibleFrame, display: true, animate: true)
        }
    }
}

extension WindowCoordinator {
    
    override func toggle(panel: SplitViewController.Panel) {
        
        orchardCoordinator.splitViewCoordinator.controller.toggle(panel: panel)
    }
}
