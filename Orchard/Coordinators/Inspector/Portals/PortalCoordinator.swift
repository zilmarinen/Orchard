//
//  PortalCoordinator.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Cocoa
import Meadow

class PortalCoordinator: Coordinator<PortalInspectorViewController> {
    
    override init(controller: PortalInspectorViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func refresh() {}
    
    func button(button: NSButton) {
        
        switch button {
        
        case controller.gridRenderingButton:
            
            editor?.portals.isHidden = button.state == .off
            
        default: break
        }
    }
    
    func popUp(popUp: NSPopUpButton) {}
}
