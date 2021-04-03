//
//  WallCoordinator.swift
//
//  Created by Zack Brown on 03/04/2021.
//

import Cocoa
import Meadow

class WallCoordinator: Coordinator<WallInspectorViewController> {
    
    override init(controller: WallInspectorViewController) {
        
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
            
            editor?.walls.isHidden = button.state == .off
            
        default: break
        }
    }
    
    func popUp(popUp: NSPopUpButton) {}
}
