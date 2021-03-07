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
            
            for foliageType in FoliageTileType.allCases {
                
                typePopUp.addItem(withTitle: foliageType.description)
            }
        }
    }
    
    weak var coordinator: FoliagePaintUtilityCoordinator?
}
