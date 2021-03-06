//
//  BuildingCoordinator.swift
//
//  Created by Zack Brown on 15/03/2021.
//

import Cocoa
import Meadow

class BuildingCoordinator: Coordinator<BuildingInspectorViewController> {
    
    override init(controller: BuildingInspectorViewController) {
        
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
            
            editor?.map.buildings.isHidden = button.state == .off
            
        default: break
        }
    }
    
    func popUp(popUp: NSPopUpButton) {}
}
