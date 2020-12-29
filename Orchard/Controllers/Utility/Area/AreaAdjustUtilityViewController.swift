//
//  AreaAdjustUtilityViewController.swift
//  Orchard
//
//  Created by Zack Brown on 28/12/2020.
//

import Cocoa
import Meadow

class AreaAdjustUtilityViewController: NSViewController {
    
    @IBOutlet weak var elevationStepper: NumberStepper! {
        
        didSet {
            
            elevationStepper.maximumValue = World.Constants.ceiling
            elevationStepper.minimumValue = 0
        }
    }
    
    weak var coordinator: AreaAdjustUtilityCoordinator?
}
