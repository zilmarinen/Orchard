//
//  InspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa

class InspectorViewController: NSViewController {
    
    @IBOutlet weak var inspectorButton: NSButton!
    @IBOutlet weak var utilityButton: NSButton!
    
    weak var coordinator: InspectorCoordinator?
    
    @IBAction func button(_ sender: NSButton) {
        
        switch sender {
        
        case inspectorButton:
            
            print("Inspector")
            
        case utilityButton:
            
            print("Utility")
            
        default: break
        }
    }
}
