//
//  SurfaceCoordinator.swift
//
//  Created by Zack Brown on 11/03/2021.
//

import Cocoa
import Meadow

class SurfaceCoordinator: Coordinator<SurfaceInspectorViewController> {
    
    override init(controller: SurfaceInspectorViewController) {
        
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
            
            editor?.map.surface.isHidden = button.state == .off
            
        default: break
        }
    }
    
    func numberStepper(numberStepper: NumberStepper) {}
    
    func popUp(popUp: NSPopUpButton) {}
}
