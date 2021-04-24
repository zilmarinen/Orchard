//
//  BuildingInspectorViewController.swift
//
//  Created by Zack Brown on 15/03/2021.
//

import Cocoa
import Meadow

class BuildingInspectorViewController: NSViewController {
    
    @IBOutlet weak var gridBox: NSBox!
    @IBOutlet weak var nodeBox: NSBox!
    @IBOutlet weak var buildBox: NSBox!
    
    @IBOutlet weak var nodeCountLabel: NSTextField!
    
    @IBOutlet weak var gridRenderingButton: NSButton!
    @IBOutlet weak var nodeRenderingButton: NSButton!
    
    @IBOutlet weak var inspectorTypePopUp: NSPopUpButton! {
        
        didSet {
            
            inspectorTypePopUp.removeAllItems()
            
            for option in BuildingType.allCases {
                
                inspectorTypePopUp.addItem(withTitle: option.description)
            }
        }
    }
    
    @IBOutlet weak var buildTypePopUp: NSPopUpButton! {
        
        didSet {
            
            buildTypePopUp.removeAllItems()
            
            for option in BuildingType.allCases {
                
                buildTypePopUp.addItem(withTitle: option.description)
            }
        }
    }
    
    @IBOutlet weak var nodeCoordinateView: CoordinateView! {
        
        didSet {
            
            nodeCoordinateView.isEnabled = false
        }
    }
    
    @IBAction func button(_ sender: NSButton) {
        
        coordinator?.button(button: sender)
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        coordinator?.popUp(popUp: sender)
    }
    
    weak var coordinator: BuildingCoordinator?
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        coordinator?.refresh()
    }
}
