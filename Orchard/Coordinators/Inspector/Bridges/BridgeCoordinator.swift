//
//  BridgeCoordinator.swift
//
//  Created by Zack Brown on 30/03/2021.
//

import Cocoa
import Meadow

class BridgeCoordinator: Coordinator<BridgeInspectorViewController> {
    
    override init(controller: BridgeInspectorViewController) {
        
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
            
            editor?.map.bridges.isHidden = button.state == .off
            
        default: break
        }
    }
    
    func popUp(popUp: NSPopUpButton) {}
}
