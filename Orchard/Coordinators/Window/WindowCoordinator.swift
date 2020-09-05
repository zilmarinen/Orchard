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
    
    override init(controller: OrchardWindowController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        guard let json = option as? Document.DocumentJSON else { fatalError("Invalid start option for window coordinator.") }
        
        let meadow = Meadow(graph: json.graph, json: json.meadow)
        
        start(child: orchardCoordinator, with: meadow)
        
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
