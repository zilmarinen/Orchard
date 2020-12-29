//
//  FoliageBuildUtilityViewController.swift
//  Orchard
//
//  Created by Zack Brown on 07/12/2020.
//

import Cocoa
import Meadow

class FoliageBuildUtilityViewController: NSViewController {
    
    @IBOutlet weak var typePopUp: NSPopUpButton! {
        
        didSet {
            
            typePopUp.removeAllItems()
            
            for footpathType in FootpathTileType.allCases {
                
                typePopUp.addItem(withTitle: footpathType.description)
            }
        }
    }
    
    weak var coordinator: FoliageBuildUtilityCoordinator?
}
