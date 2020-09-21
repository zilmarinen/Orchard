//
//  WaterUtilityViewController.swift
//  Orchard
//
//  Created by Zack Brown on 31/07/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import AppKit

class WaterUtilityViewController: NSViewController {
    
    weak var coordinator: WaterUtilityCoordinator?
    
    @IBOutlet weak var gridBox: NSBox!
    @IBOutlet weak var buildBox: NSBox!
    @IBOutlet weak var paintBox: NSBox!
    
    @IBOutlet weak var chunkCountLabel: NSTextField!
    
    @IBOutlet weak var gridRenderingButton: NSButton!
    
    @IBOutlet weak var utilityTypePopUp: NSPopUpButton!
    
    //
    /// Build
    //
    
    @IBOutlet weak var buildToolTypePopUp: NSPopUpButton!
    @IBOutlet weak var buildTypePopUp: NSPopUpButton!
    
    //
    /// Paint
    //
    
    @IBOutlet weak var paintToolTypePopUp: NSPopUpButton!
    @IBOutlet weak var paintTypePopUp: NSPopUpButton!

    @IBAction func button(_ sender: NSButton) {
        
        switch sender {
            
        case gridRenderingButton:
            
            switch coordinator?.viewModel.state {
                
            case .build(let inspector, _, _),
                 .paint(let inspector, _, _):
                
                inspector.inspectable.grid.isHidden = sender.state == .off
                
            default: break
            }
            
        default: break
        }
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch sender {
            
        case utilityTypePopUp:
            
            guard let utility = WaterUtilityCoordinator.Utility(rawValue: sender.indexOfSelectedItem) else { return }
            
            coordinator?.viewModel.switch(utility: utility)
            
        case buildToolTypePopUp,
             paintToolTypePopUp:
            
            guard let toolType = WaterUtilityCoordinator.ToolType(rawValue: sender.indexOfSelectedItem) else { return }
            
            coordinator?.viewModel.set(toolType: toolType)
            
        case buildTypePopUp,
             paintTypePopUp:
            
            guard let waterType = WaterType(rawValue: sender.indexOfSelectedItem) else { return }
            
            coordinator?.viewModel.set(waterType: waterType)
            
        default: break
        }
    }
}
