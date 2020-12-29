//
//  FoliageInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 07/12/2020.
//

import Cocoa
import Meadow

class FoliageInspectorViewController: NSViewController {
    
    @IBOutlet weak var gridBox: NSBox!
    @IBOutlet weak var chunkBox: NSBox!
    @IBOutlet weak var tileBox: NSBox!
    
    @IBOutlet weak var chunkCountLabel: NSTextField!
    @IBOutlet weak var tileCountLabel: NSTextField!
    @IBOutlet weak var neighbourCountLabel: NSTextField!
    
    @IBOutlet weak var gridRenderingButton: NSButton!
    @IBOutlet weak var chunkRenderingButton: NSButton!
    @IBOutlet weak var tileRenderingButton: NSButton!
    
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
    
    @IBAction func button(_ sender: NSButton) {
        
        guard let inspectable = coordinator?.inspectable else { return }
        
        switch sender {
        
        case gridRenderingButton:
            
            inspectable.foliage.isHidden = sender.state == .off
            
        case chunkRenderingButton:
            
            inspectable.chunk?.isHidden = sender.state == .off
            
        case tileRenderingButton:
            
            inspectable.tile?.isHidden = sender.state == .off
            
        default: break
        }
        
        coordinator?.refresh()
    }
    
    weak var coordinator: FoliageInspectorCoordinator?
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        coordinator?.refresh()
    }
}
