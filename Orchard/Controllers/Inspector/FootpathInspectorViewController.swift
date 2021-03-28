//
//  FootpathInspectorViewController.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Cocoa
import Meadow

class FootpathInspectorViewController: NSViewController {
    
    @IBOutlet weak var gridBox: NSBox!
    @IBOutlet weak var tileBox: NSBox!
    @IBOutlet weak var materialBox: NSBox!
    
    @IBOutlet weak var chunkCountLabel: NSTextField!
    @IBOutlet weak var neighbourCountLabel: NSTextField!
    
    @IBOutlet weak var gridRenderingButton: NSButton!
    @IBOutlet weak var tileRenderingButton: NSButton!
    
    @IBOutlet weak var inspectorTypePopUp: NSPopUpButton! {
        
        didSet {
            
            inspectorTypePopUp.removeAllItems()
            
            for option in FootpathTileType.allCases {
                
                inspectorTypePopUp.addItem(withTitle: option.description)
            }
        }
    }
    
    @IBOutlet weak var materialTypePopUp: NSPopUpButton! {
        
        didSet {
            
            materialTypePopUp.removeAllItems()
            
            for option in FootpathTileType.allCases {
                
                materialTypePopUp.addItem(withTitle: option.description)
            }
        }
    }
    
    @IBOutlet weak var tileCoordinateView: CoordinateView! {
        
        didSet {
            
            tileCoordinateView.isEnabled = false
        }
    }
    
    @IBAction func button(_ sender: NSButton) {
        
        coordinator?.button(button: sender)
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        coordinator?.popUp(popUp: sender)
    }
    
    weak var coordinator: FootpathCoordinator?
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        coordinator?.refresh()
    }
}
