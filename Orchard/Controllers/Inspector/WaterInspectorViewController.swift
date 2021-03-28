//
//  WaterInspectorViewController.swift
//
//  Created by Zack Brown on 21/03/2021.
//

import Cocoa
import Meadow

class WaterInspectorViewController: NSViewController {
    
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
            
            for option in WaterTileType.allCases {
                
                inspectorTypePopUp.addItem(withTitle: option.description)
            }
        }
    }
    
    @IBOutlet weak var materialTypePopUp: NSPopUpButton! {
        
        didSet {
            
            materialTypePopUp.removeAllItems()
            
            for option in WaterTileType.allCases {
                
                materialTypePopUp.addItem(withTitle: option.description)
            }
        }
    }
    
    @IBOutlet weak var tileCoordinateView: CoordinateView! {
        
        didSet {
            
            tileCoordinateView.xStepper.isEnabled = false
            tileCoordinateView.zStepper.isEnabled = false
            
            tileCoordinateView.yStepper.maximumValue = World.Constants.ceiling
            tileCoordinateView.yStepper.minimumValue = World.Constants.floor
            
            tileCoordinateView.yStepper.valueDidChange = { [weak self] (numberStepper , value) in
                
                guard let self = self else { return }
                
                self.coordinator?.numberStepper(numberStepper: numberStepper)
            }
        }
    }
    
    @IBOutlet weak var materialLayerStepper: NumberStepper! {
        
        didSet {
            
            materialLayerStepper.maximumValue = World.Constants.ceiling
            materialLayerStepper.minimumValue = World.Constants.floor
        }
    }
    
    @IBAction func button(_ sender: NSButton) {
        
        coordinator?.button(button: sender)
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        coordinator?.popUp(popUp: sender)
    }
    
    weak var coordinator: WaterCoordinator?
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        coordinator?.refresh()
    }
}
