//
//  TerrainInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 06/11/2020.
//

import Cocoa
import Meadow

class TerrainInspectorViewController: NSViewController {
    
    @IBOutlet weak var gridBox: NSBox!
    @IBOutlet weak var chunkBox: NSBox!
    @IBOutlet weak var tileBox: NSBox!
    
    @IBOutlet weak var chunkCountLabel: NSTextField!
    @IBOutlet weak var tileCountLabel: NSTextField!
    @IBOutlet weak var neighbourCountLabel: NSTextField!
    
    @IBOutlet weak var gridRenderingButton: NSButton!
    @IBOutlet weak var chunkRenderingButton: NSButton!
    @IBOutlet weak var tileRenderingButton: NSButton!
    
    @IBOutlet weak var typePopUp: NSPopUpButton! {
        
        didSet {
            
            typePopUp.removeAllItems()
            
            for terrainType in TerrainTileType.allCases {
                
                typePopUp.addItem(withTitle: terrainType.description)
            }
        }
    }
    
    @IBOutlet weak var slopeButton: NSButton!
    @IBOutlet weak var directionPopUp: NSPopUpButton! {
        
        didSet {
            
            directionPopUp.removeAllItems()
            
            for cardinal in Cardinal.allCases {
                
                directionPopUp.addItem(withTitle: cardinal.description)
            }
        }
    }
    
    @IBOutlet weak var chunkCoordinateView: CoordinateView! {
        
        didSet {
            
            chunkCoordinateView.isEnabled = false
        }
    }
    
    @IBOutlet weak var tileCoordinateView: CoordinateView! {
        
        didSet {
            
            tileCoordinateView.xStepper.isEnabled = false
            tileCoordinateView.zStepper.isEnabled = false
            
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
            
            inspectable.terrain.isHidden = sender.state == .off
            
        case chunkRenderingButton:
            
            inspectable.chunk?.isHidden = sender.state == .off
            
        case tileRenderingButton:
            
            inspectable.tile?.isHidden = sender.state == .off
            
        case slopeButton:
            
            switch slopeButton.state {
            
            case .on:
                
                guard let cardinal = Cardinal(rawValue: directionPopUp.indexOfSelectedItem) else { return }
                
                inspectable.tile?.slope = cardinal
                
            default:
                
                inspectable.tile?.slope = nil
            }
            
        default: break
        }
        
        coordinator?.refresh()
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        guard let inspectable = coordinator?.inspectable else { return }
        
        switch sender {
        
        case typePopUp:
            
            guard let tileType = TerrainTileType(rawValue: typePopUp.indexOfSelectedItem) else { return }
            
            inspectable.tile?.tileType = tileType
            
        case directionPopUp:
            
            guard let cardinal = Cardinal(rawValue: directionPopUp.indexOfSelectedItem) else { return }
            
            inspectable.tile?.slope = cardinal
            
        default: break
        }
        
        coordinator?.refresh()
    }
    
    weak var coordinator: TerrainInspectorCoordinator?
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        coordinator?.refresh()
    }
}
