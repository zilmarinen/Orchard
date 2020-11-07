//
//  TerrainPaintUtilityViewController.swift
//  Orchard
//
//  Created by Zack Brown on 06/11/2020.
//

import Cocoa

class TerrainPaintUtilityViewController: NSViewController {
    
    @IBOutlet weak var typePopUp: NSPopUpButton! {
        
        didSet {
            
            typePopUp.removeAllItems()
            
            let type = ["One", "Two"]
            
            type.forEach { t in
                
                typePopUp.addItem(withTitle: t)
            }
        }
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
    }
    
    weak var coordinator: TerrainPaintUtilityCoordinator?
}
