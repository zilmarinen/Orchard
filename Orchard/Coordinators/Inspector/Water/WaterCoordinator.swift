//
//  WaterCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 21/03/2021.
//

import Cocoa
import Meadow

class WaterCoordinator: Coordinator<WaterInspectorViewController> {
    
    override init(controller: WaterInspectorViewController) {
        
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
            
            editor?.water.isHidden = button.state == .off
            
        default: break
        }
    }
    
    func numberStepper(numberStepper: NumberStepper) {}
    
    func popUp(popUp: NSPopUpButton) {}
}

