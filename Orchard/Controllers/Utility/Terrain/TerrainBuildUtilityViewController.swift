//
//  TerrainBuildUtilityViewController.swift
//  Orchard
//
//  Created by Zack Brown on 05/11/2020.
//

import Cocoa
import Meadow

class TerrainBuildUtilityViewController: NSViewController {
    
    @IBOutlet weak var typePopUp: NSPopUpButton! {
        
        didSet {
            
            typePopUp.removeAllItems()
            
            for terrainType in TerrainTileType.allCases {
                
                typePopUp.addItem(withTitle: terrainType.description)
            }
        }
    }
    
    @IBOutlet weak var elevationStepper: NumberStepper! {
        
        didSet {
            
            elevationStepper.maximumValue = World.Constants.ceiling
            elevationStepper.minimumValue = 0
        }
    }
    
    weak var coordinator: TerrainBuildUtilityCoordinator?
}
