//
//  ActorCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 28/03/2021.
//

import Cocoa
import Meadow

class ActorCoordinator: Coordinator<ActorInspectorViewController> {
    
    override init(controller: ActorInspectorViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func refresh() {}
    
    func button(button: NSButton) {
        
        switch button {
        
        //case controller.gridRenderingButton:
            
            //editor?.actors.isHidden = button.state == .off
            
        default: break
        }
    }
}
