//
//  AreaPaintUtilityViewController.swift
//  Orchard
//
//  Created by Zack Brown on 08/12/2020.
//

import Cocoa
import Meadow

class AreaPaintUtilityViewController: NSViewController {
    
    @IBOutlet weak var typePopUp: NSPopUpButton! {
        
        didSet {
            
            typePopUp.removeAllItems()
            
            for areaType in AreaTileType.allCases {
                
                typePopUp.addItem(withTitle: areaType.description)
            }
        }
    }
    
    weak var coordinator: AreaPaintUtilityCoordinator?
}
