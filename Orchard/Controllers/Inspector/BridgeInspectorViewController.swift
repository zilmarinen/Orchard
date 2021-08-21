//
//  BridgeInspectorViewController.swift
//
//  Created by Zack Brown on 30/03/2021.
//

import Cocoa
import Meadow

class BridgeInspectorViewController: NSViewController {
    
    @IBOutlet weak var gridBox: NSBox!
    @IBOutlet weak var tileBox: NSBox!
    @IBOutlet weak var buildBox: NSBox!
    
    @IBOutlet weak var chunkCountLabel: NSTextField!
    @IBOutlet weak var neighbourCountLabel: NSTextField!
    
    @IBOutlet weak var gridRenderingButton: NSButton!
    @IBOutlet weak var tileRenderingButton: NSButton!
    
    @IBOutlet weak var inspectorMaterialPopUp: NSPopUpButton! {
        
        didSet {
            
            inspectorMaterialPopUp.removeAllItems()
            
            for option in BridgeMaterial.allCases {
                
                inspectorMaterialPopUp.addItem(withTitle: option.id.capitalized)
            }
        }
    }
    
    @IBOutlet weak var buildMaterialPopUp: NSPopUpButton! {
        
        didSet {
            
            buildMaterialPopUp.removeAllItems()
            
            for option in BridgeMaterial.allCases {
                
                buildMaterialPopUp.addItem(withTitle: option.id.capitalized)
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
    
    weak var coordinator: BridgeCoordinator?
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        coordinator?.refresh()
    }
}
