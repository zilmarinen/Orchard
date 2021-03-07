//
//  PortalBuildUtilityViewController.swift
//  Orchard
//
//  Created by Zack Brown on 09/12/2020.
//

import Cocoa
import Meadow

class PortalBuildUtilityViewController: NSViewController {
    
    @IBOutlet weak var typePopUp: NSPopUpButton! {
        
        didSet {
            
            typePopUp.removeAllItems()
            
            for terrainType in TerrainTileType.allCases {
                
                typePopUp.addItem(withTitle: terrainType.description)
            }
        }
    }
    
    @IBOutlet weak var idetifierLabel: NSTextField!
    
    weak var coordinator: PortalBuildUtilityCoordinator?
}
