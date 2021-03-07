//
//  BuildingInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 01/02/2021.
//

import Cocoa
import Meadow

class BuildingInspectorViewController: NSViewController {
    
    @IBOutlet weak var gridBox: NSBox!
    @IBOutlet weak var chunkBox: NSBox!
    @IBOutlet weak var tileBox: NSBox!
    @IBOutlet weak var layerBox: NSBox!
    
    @IBOutlet weak var chunkCountLabel: NSTextField!
    @IBOutlet weak var tileCountLabel: NSTextField!
    @IBOutlet weak var layerCountLabel: NSTextField!
    @IBOutlet weak var neighbourCountLabel: NSTextField!
    
    @IBOutlet weak var gridRenderingButton: NSButton!
    @IBOutlet weak var chunkRenderingButton: NSButton!
    @IBOutlet weak var tileRenderingButton: NSButton!
    @IBOutlet weak var layerRenderingButton: NSButton!
    
    @IBOutlet weak var layerPopUp: NSPopUpButton! {
        
        didSet {
            
            layerPopUp.removeAllItems()
        }
    }
    
    @IBOutlet weak var layerColorWell: NSColorWell!
    
    @IBOutlet weak var chunkCoordinateView: CoordinateView! {
        
        didSet {
            
            chunkCoordinateView.isEnabled = false
        }
    }
    
    @IBOutlet weak var tileCoordinateView: CoordinateView! {
        
        didSet {
            
            tileCoordinateView.xStepper.isEnabled = false
            tileCoordinateView.zStepper.isEnabled = false
            
            tileCoordinateView.yStepper.maximumValue = World.Constants.ceiling
            tileCoordinateView.yStepper.minimumValue = World.Constants.floor
            
            tileCoordinateView.valueDidChange = { [weak self] (stepper, coordinate) in
                
                guard let self = self, let inspectable = self.coordinator?.inspectable else { return }
                
                inspectable.tile?.coordinate = coordinate
            }
        }
    }
    
    @IBAction func colorWell(_ sender: NSColorWell) {
        
        guard let inspectable = coordinator?.inspectable else { return }
        
        switch sender {
        
        case layerColorWell:
            
            guard let layer = inspectable.layer else { return }
            
            layer.color = Color(red: Double(sender.color.redComponent), green: Double(sender.color.greenComponent), blue: Double(sender.color.blueComponent), alpha: Double(sender.color.alphaComponent))
            
        default: break
        }
    }
    
    @IBAction func button(_ sender: NSButton) {
        
        guard let inspectable = coordinator?.inspectable else { return }
        
        switch sender {
        
        case gridRenderingButton:
            
            inspectable.buildings.isHidden = sender.state == .off
            
        case chunkRenderingButton:
            
            inspectable.chunk?.isHidden = sender.state == .off
            
        case tileRenderingButton:
            
            inspectable.tile?.isHidden = sender.state == .off
            
        default: break
        }
        
        coordinator?.refresh()
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        guard let inspectable = coordinator?.inspectable else { return }
        
        switch sender {
        
        case layerPopUp:
            
            guard let tile = inspectable.tile,
                  let layer = tile.find(layer: sender.indexOfSelectedItem) else { return }
            
            coordinator?.didSelect(node: layer)
            
        default: break
        }
    }
    
    weak var coordinator: BuildingInspectorCoordinator?
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        coordinator?.refresh()
    }
}
