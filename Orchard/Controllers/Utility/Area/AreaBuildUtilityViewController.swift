//
//  AreaBuildUtilityViewController.swift
//  Orchard
//
//  Created by Zack Brown on 08/12/2020.
//

import Cocoa
import Meadow

class AreaBuildUtilityViewController: NSViewController {
    
    @IBOutlet weak var typePopUp: NSPopUpButton! {
        
        didSet {
            
            typePopUp.removeAllItems()
            
            for areaType in AreaTileType.allCases {
                
                typePopUp.addItem(withTitle: areaType.description)
            }
        }
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
    }
    
    weak var coordinator: AreaBuildUtilityCoordinator?
}
