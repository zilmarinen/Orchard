//
//  FootpathPaintUtilityViewController.swift
//  Orchard
//
//  Created by Zack Brown on 03/12/2020.
//

import Cocoa
import Meadow

class FootpathPaintUtilityViewController: NSViewController {
    
    @IBOutlet weak var typePopUp: NSPopUpButton! {
        
        didSet {
            
            typePopUp.removeAllItems()
            
            for footpathType in FootpathTileType.allCases {
                
                typePopUp.addItem(withTitle: footpathType.description)
            }
        }
    }
    
    weak var coordinator: FootpathPaintUtilityCoordinator?
}
