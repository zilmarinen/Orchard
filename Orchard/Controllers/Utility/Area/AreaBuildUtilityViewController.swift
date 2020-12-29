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
    
    @IBOutlet weak var elevationStepper: NumberStepper! {
        
        didSet {
            
            elevationStepper.maximumValue = World.Constants.ceiling
            elevationStepper.minimumValue = 0
        }
    }
    
    weak var coordinator: AreaBuildUtilityCoordinator?
}
