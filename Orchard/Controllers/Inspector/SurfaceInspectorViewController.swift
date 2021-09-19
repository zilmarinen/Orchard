//
//  SurfaceInspectorViewController.swift
//
//  Created by Zack Brown on 06/11/2020.
//

import Cocoa
import Meadow

class SurfaceInspectorViewController: NSViewController {
    
    @IBOutlet weak var gridBox: NSBox!
    @IBOutlet weak var tileBox: NSBox!
    @IBOutlet weak var materialBox: NSBox!
    @IBOutlet weak var elevationBox: NSBox!
    @IBOutlet weak var edgeBox: NSBox!
    
    @IBOutlet weak var chunkCountLabel: NSTextField!
    @IBOutlet weak var neighbourCountLabel: NSTextField!
    
    @IBOutlet weak var gridRenderingButton: NSButton!
    @IBOutlet weak var tileRenderingButton: NSButton!
    
    @IBOutlet weak var inspectorTileTypePopUp: NSPopUpButton! {
        
        didSet {
            
            inspectorTileTypePopUp.removeAllItems()
            
            for option in SurfaceTileType.allCases {
                
                inspectorTileTypePopUp.addItem(withTitle: option.description)
            }
        }
    }
    
    @IBOutlet weak var buildTileTypePopUp: NSPopUpButton! {
        
        didSet {
            
            buildTileTypePopUp.removeAllItems()
            
            for option in SurfaceTileType.allCases {
                
                buildTileTypePopUp.addItem(withTitle: option.description)
            }
        }
    }
    
    @IBOutlet weak var inspectorMaterialPopUp: NSPopUpButton! {
        
        didSet {
            
            inspectorMaterialPopUp.removeAllItems()
            
            for option in SurfaceMaterial.allCases {
                
                inspectorMaterialPopUp.addItem(withTitle: option.description)
            }
            
            inspectorMaterialPopUp.addItem(withTitle: "None")
            inspectorMaterialPopUp.selectItem(at: inspectorMaterialPopUp.numberOfItems - 1)
        }
    }
    
    @IBOutlet weak var buildMaterialPopUp: NSPopUpButton! {
        
        didSet {
            
            buildMaterialPopUp.removeAllItems()
            
            for option in SurfaceMaterial.allCases {
                
                buildMaterialPopUp.addItem(withTitle: option.description)
            }
            
            buildMaterialPopUp.addItem(withTitle: "None")
            buildMaterialPopUp.selectItem(at: buildMaterialPopUp.numberOfItems - 1)
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
            materialLayerStepper.integerValue = Int(World.Constants.ceiling / 2)
        }
    }
    
    @IBOutlet weak var elevationLayerStepper: NumberStepper! {
        
        didSet {
            
            elevationLayerStepper.maximumValue = World.Constants.ceiling
            elevationLayerStepper.minimumValue = World.Constants.floor
            elevationLayerStepper.integerValue = Int(World.Constants.ceiling / 2)
        }
    }
    
    @IBOutlet weak var buildSurfaceTypePopUp: NSPopUpButton! {
        
        didSet {
            
            buildSurfaceTypePopUp.removeAllItems()
            
            for option in SurfaceType.allCases {
                
                buildSurfaceTypePopUp.addItem(withTitle: option.description)
            }
        }
    }
    
    @IBOutlet weak var surfaceTypePopUp: NSPopUpButton! {
        
        didSet {
            
            surfaceTypePopUp.removeAllItems()
            
            for option in SurfaceType.allCases {
                
                surfaceTypePopUp.addItem(withTitle: option.description)
            }
        }
    }
    
    @IBAction func button(_ sender: NSButton) {
        
        coordinator?.button(button: sender)
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        coordinator?.popUp(popUp: sender)
    }
    
    weak var coordinator: SurfaceCoordinator?
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        coordinator?.refresh()
    }
}
