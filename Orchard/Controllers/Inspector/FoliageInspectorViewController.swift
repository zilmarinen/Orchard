//
//  FoliageInspectorViewController.swift
//
//  Created by Zack Brown on 15/03/2021.
//

import Cocoa
import Meadow

class FoliageInspectorViewController: NSViewController {
    
    @IBOutlet weak var gridBox: NSBox!
    @IBOutlet weak var nodeBox: NSBox!
    @IBOutlet weak var plantBox: NSBox!
    
    @IBOutlet weak var nodeCountLabel: NSTextField!
    
    @IBOutlet weak var gridRenderingButton: NSButton!
    @IBOutlet weak var nodeRenderingButton: NSButton!
    
    @IBOutlet weak var inspectorTypePopUp: NSPopUpButton! {
        
        didSet {
            
            inspectorTypePopUp.removeAllItems()
            
            for option in FoliageType.allCases {
                
                inspectorTypePopUp.addItem(withTitle: option.description)
            }
        }
    }
    
    @IBOutlet weak var plantTypePopUp: NSPopUpButton! {
        
        didSet {
            
            plantTypePopUp.removeAllItems()
            
            for option in FoliageType.allCases {
                
                plantTypePopUp.addItem(withTitle: option.description)
            }
        }
    }
    
    @IBOutlet weak var inspectorSizePopUp: NSPopUpButton! {
        
        didSet {
            
            inspectorSizePopUp.isEnabled = false
            inspectorSizePopUp.removeAllItems()
            
            for option in FoliageSize.allCases {
                
                inspectorSizePopUp.addItem(withTitle: option.description)
            }
        }
    }
    
    @IBOutlet weak var plantSizePopUp: NSPopUpButton! {
        
        didSet {
            
            plantSizePopUp.removeAllItems()
            
            for option in FoliageSize.allCases {
                
                plantSizePopUp.addItem(withTitle: option.description)
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
    
    weak var coordinator: FoliageCoordinator?
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        coordinator?.refresh()
    }
}
