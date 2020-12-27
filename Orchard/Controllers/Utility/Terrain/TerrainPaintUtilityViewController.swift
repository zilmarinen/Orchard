//
//  TerrainPaintUtilityViewController.swift
//  Orchard
//
//  Created by Zack Brown on 06/11/2020.
//

import Cocoa
import Meadow

class TerrainPaintUtilityViewController: NSViewController {
    
    @IBOutlet weak var typePopUp: NSPopUpButton! {
        
        didSet {
            
            typePopUp.removeAllItems()
            
            for terrainType in TerrainTileType.allCases {
                
                typePopUp.addItem(withTitle: terrainType.description)
            }
        }
    }
    
    weak var coordinator: TerrainPaintUtilityCoordinator?
}
