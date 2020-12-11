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
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
    }
    
    weak var coordinator: TerrainBuildUtilityCoordinator?
}
