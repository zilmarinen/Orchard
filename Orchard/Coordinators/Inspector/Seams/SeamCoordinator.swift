//
//  SeamCoordinator.swift
//
//  Created by Zack Brown on 01/06/2021.
//

import Cocoa
import Meadow

class SeamCoordinator: Coordinator<SeamInspectorViewController> {
    
    override init(controller: SeamInspectorViewController) {
        
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
            
            editor?.harvest.seams.isHidden = button.state == .off
            
        default: break
        }
    }
    
    func popUp(popUp: NSPopUpButton) {}
    
    func textField(textField: NSTextField) {}
}
