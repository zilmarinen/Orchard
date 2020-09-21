//
//  TerrainUtilityViewController.swift
//  Orchard
//
//  Created by Zack Brown on 20/05/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import AppKit

class TerrainUtilityViewController: NSViewController {
    
    weak var coordinator: TerrainUtilityCoordinator?
    
    @IBOutlet weak var gridBox: NSBox!
    @IBOutlet weak var buildBox: NSBox!
    @IBOutlet weak var paintBox: NSBox!
    @IBOutlet weak var terraformBox: NSBox!
    
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
    
    //
    /// Terraform
    //
     
    @IBAction func button(_ sender: NSButton) {
        
        switch sender {
            
        case gridRenderingButton:
            
            switch coordinator?.viewModel.state {
                
            case .build(let inspector, _, _),
                 .paint(let inspector, _, _),
                 .terraform(let inspector):
                
                inspector.inspectable.grid.isHidden = sender.state == .off
                
            default: break
            }
            
        default: break
        }
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch sender {
            
        case utilityTypePopUp:
            
            guard let utility = TerrainUtilityCoordinator.Utility(rawValue: sender.indexOfSelectedItem) else { return }
            
            coordinator?.viewModel.switch(utility: utility)
            
        case buildToolTypePopUp,
             paintToolTypePopUp:
            
            guard let toolType = TerrainUtilityCoordinator.ToolType(rawValue: sender.indexOfSelectedItem) else { return }
            
            coordinator?.viewModel.set(toolType: toolType)
            
        case buildTypePopUp,
             paintTypePopUp:
            
            guard let terrainType = TerrainType(rawValue: sender.indexOfSelectedItem) else { return }
            
            coordinator?.viewModel.set(terrainType: terrainType)
            
        default: break
        }
    }
}
