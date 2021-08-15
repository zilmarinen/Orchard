//
//  StairsInspectorViewController.swift
//
//  Created by Zack Brown on 30/03/2021.
//

import Cocoa
import Meadow

class StairsInspectorViewController: NSViewController {
    
    @IBOutlet weak var gridBox: NSBox!
    @IBOutlet weak var nodeBox: NSBox!
    @IBOutlet weak var buildBox: NSBox!
    
    @IBOutlet weak var nodeCountLabel: NSTextField!
    
    @IBOutlet weak var gridRenderingButton: NSButton!
    @IBOutlet weak var nodeRenderingButton: NSButton!
    
    @IBOutlet weak var inspectorTypePopUp: NSPopUpButton! {
        
        didSet {
            
            inspectorTypePopUp.removeAllItems()
            
            for option in StairType.allCases {
                
                inspectorTypePopUp.addItem(withTitle: option.id.capitalized)
            }
        }
    }
    
    @IBOutlet weak var buildTypePopUp: NSPopUpButton! {
        
        didSet {
            
            buildTypePopUp.removeAllItems()
            
            for option in StairType.allCases {
                
                buildTypePopUp.addItem(withTitle: option.id.capitalized)
            }
        }
    }
    
    @IBOutlet weak var inspectorMaterialPopUp: NSPopUpButton! {
        
        didSet {
            
            inspectorMaterialPopUp.removeAllItems()
            
            for option in StairMaterial.allCases {
                
                inspectorMaterialPopUp.addItem(withTitle: option.id.capitalized)
            }
        }
    }
    
    @IBOutlet weak var buildMaterialPopUp: NSPopUpButton! {
        
        didSet {
            
            buildMaterialPopUp.removeAllItems()
            
            for option in StairMaterial.allCases {
                
                buildMaterialPopUp.addItem(withTitle: option.id.capitalized)
            }
        }
    }
    
    @IBOutlet weak var inspectorDirectionPopUp: NSPopUpButton! {
        
        didSet {
            
            inspectorDirectionPopUp.removeAllItems()
            
            for option in Cardinal.allCases {
                
                inspectorDirectionPopUp.addItem(withTitle: option.description)
            }
        }
    }
    
    @IBOutlet weak var buildDirectionPopUp: NSPopUpButton! {
        
        didSet {
            
            buildDirectionPopUp.removeAllItems()
            
            for option in Cardinal.allCases {
                
                buildDirectionPopUp.addItem(withTitle: option.description)
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
    
    weak var coordinator: StairsCoordinator?
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        coordinator?.refresh()
    }
}

