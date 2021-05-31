//
//  StairsCoordinator.swift
//
//  Created by Zack Brown on 30/03/2021.
//

import Cocoa
import Meadow

class StairsCoordinator: Coordinator<StairsInspectorViewController> {
    
    override init(controller: StairsInspectorViewController) {
        
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
            
            editor?.harvest.stairs.isHidden = button.state == .off
            
        default: break
        }
    }
    
    func popUp(popUp: NSPopUpButton) {}
}
