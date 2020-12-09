//
//  FoliagePaintUtilityViewController.swift
//  Orchard
//
//  Created by Zack Brown on 07/12/2020.
//

import Cocoa
import Meadow

class FoliagePaintUtilityViewController: NSViewController {
    
    @IBOutlet weak var typePopUp: NSPopUpButton! {
        
        didSet {
            
            typePopUp.removeAllItems()
            
            for footpathType in FootpathTileType.allCases {
                
                typePopUp.addItem(withTitle: footpathType.description)
            }
        }
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
    }
    
    weak var coordinator: FoliagePaintUtilityCoordinator?
}
