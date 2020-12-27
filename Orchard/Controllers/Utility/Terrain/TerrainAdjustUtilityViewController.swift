//
//  TerrainAdjustUtilityViewController.swift
//  Orchard
//
//  Created by Zack Brown on 16/12/2020.
//

import Cocoa
import Meadow

class TerrainAdjustUtilityViewController: NSViewController {
    
    @IBOutlet weak var elevationStepper: NumberStepper! {
        
        didSet {
            
            elevationStepper.maximumValue = World.Constants.ceiling
            elevationStepper.minimumValue = 0
        }
    }
    
    weak var coordinator: TerrainAdjustUtilityCoordinator?
}
