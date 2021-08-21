//
//  WallInspectorViewController.swift
//
//  Created by Zack Brown on 03/04/2021.
//

import Cocoa
import Meadow

class WallInspectorViewController: NSViewController {
    
    @IBOutlet weak var gridBox: NSBox!
    @IBOutlet weak var nodeBox: NSBox!
    @IBOutlet weak var buildBox: NSBox!
    
    @IBOutlet weak var nodeCountLabel: NSTextField!
    
    @IBOutlet weak var gridRenderingButton: NSButton!
    @IBOutlet weak var nodeRenderingButton: NSButton!
    
    @IBOutlet weak var inspectorTypePopUp: NSPopUpButton! {
        
        didSet {
            
            inspectorTypePopUp.removeAllItems()
            
            for option in FoliageType.allCases {
                
                inspectorTypePopUp.addItem(withTitle: option.id.capitalized)
            }
        }
    }
    
    @IBOutlet weak var inspectorMaterialPopUp: NSPopUpButton! {
        
        didSet {
            
            inspectorMaterialPopUp.removeAllItems()
            
            for option in WallTileMaterial.allCases {
                
                inspectorMaterialPopUp.addItem(withTitle: option.id.capitalized)
            }
        }
    }
    
    @IBOutlet weak var buildTypePopUp: NSPopUpButton! {
        
        didSet {
            
            buildTypePopUp.removeAllItems()
            
            for option in WallTileType.allCases {
                
                buildTypePopUp.addItem(withTitle: option.description)
            }
        }
    }
    
    @IBOutlet weak var buildMaterialPopUp: NSPopUpButton! {
        
        didSet {
            
            buildMaterialPopUp.removeAllItems()
            
            for option in WallTileMaterial.allCases {
                
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
    
    weak var coordinator: WallCoordinator?
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        coordinator?.refresh()
    }
}
