//
//  TerrainInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 27/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Pasture
import AppKit

class TerrainInspectorViewController: NSViewController, Inspector {
    
    weak var coordinator: TerrainInspectorCoordinator?
    
    @IBOutlet weak var gridBox: NSBox!
    @IBOutlet weak var chunkBox: NSBox!
    @IBOutlet weak var tileBox: NSBox!
    @IBOutlet weak var edgeBox: NSBox!
    @IBOutlet weak var layerBox: NSBox!
    
    @IBOutlet weak var chunkCountLabel: NSTextField!
    @IBOutlet weak var tileCountLabel: NSTextField!
    @IBOutlet weak var edgeCountLabel: NSTextField!
    @IBOutlet weak var layerCountLabel: NSTextField!
    
    @IBOutlet weak var gridRenderingButton: NSButton!
    @IBOutlet weak var chunkRenderingButton: NSButton!
    @IBOutlet weak var tileRenderingButton: NSButton!
    @IBOutlet weak var edgeRenderingButton: NSButton!
    @IBOutlet weak var layerRenderingButton: NSButton!
    
    @IBOutlet weak var edgePopUp: NSPopUpButton!
    @IBOutlet weak var layerPopUp: NSPopUpButton!
    @IBOutlet weak var terrainTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var leftCornerElevationTextField: NSTextField!
    @IBOutlet weak var rightCornerElevationTextField: NSTextField!
    @IBOutlet weak var centreCornerElevationTextField: NSTextField!
    
    @IBOutlet weak var leftCornerElevationStepper: NSStepper!
    @IBOutlet weak var rightCornerElevationStepper: NSStepper!
    @IBOutlet weak var centreCornerElevationStepper: NSStepper!
    
    @IBAction func button(_ sender: NSButton) {
        
        guard let inspectable = inspector?.inspectable else { return }
        
        switch sender {
            
        case gridRenderingButton:
            
            inspectable.grid.isHidden = sender.state == .off
            
        case chunkRenderingButton:
            
            guard let chunk = inspectable.chunk else { return }
            
            chunk.isHidden = sender.state == .off
        
        case tileRenderingButton:
            
            guard let tile = inspectable.tile else { return }
            
            tile.isHidden = sender.state == .off
            
        case edgeRenderingButton:
            
            guard let edge = inspectable.edge else { return }
            
            edge.isHidden = sender.state == .off
            
        case layerRenderingButton:
            
            guard let layer = inspectable.layer else { return }
            
            layer.isHidden = sender.state == .off
            
        default: break
        }
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        guard let inspectable = inspector?.inspectable else { return }
        
        switch sender {
            
        case edgePopUp:
            
            guard let tile = inspectable.tile, let cardinal = Cardinal(rawValue: sender.indexOfSelectedItem), let edge = tile.find(edge: cardinal) else { return }
            
            self.coordinator?.didSelect(node: edge)
            
        case layerPopUp:
            
            guard let edge = inspectable.edge, let layer = edge.find(layer: sender.indexOfSelectedItem) else { return }
            
            self.coordinator?.didSelect(node: layer)
            
        case terrainTypePopUp:
            
            guard let layer = inspectable.layer, let terrainType = TerrainType(rawValue: sender.indexOfSelectedItem) else { return }
            
            layer.terrainType = terrainType
            
        default: break
        }
    }
    
    @IBAction func stepper(_ sender: NSStepper) {
        
        guard let inspectable = inspector?.inspectable, let layer = inspectable.layer else { return }
        
        switch sender {
         
        case leftCornerElevationStepper: layer.set(elevation: sender.integerValue, corner: .left)
        case rightCornerElevationStepper: layer.set(elevation: sender.integerValue, corner: .right)
        case centreCornerElevationStepper: layer.set(elevation: sender.integerValue, corner: .centre)
            
        default: break
        }
        
        update()
    }
    
    var inspector: TerrainInspector? {
        
        didSet {
            
            guard self.isViewLoaded else { return }
            
            update()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        update()
    }
}

extension TerrainInspectorViewController {
    
    func update() {
        
        guard let inspectable = inspector?.inspectable else { return }
        
        self.chunkBox.isHidden = inspectable.chunk == nil
        self.tileBox.isHidden = inspectable.tile == nil
        self.edgeBox.isHidden = inspectable.edge == nil
        self.layerBox.isHidden = inspectable.layer == nil
        
        self.chunkCountLabel.integerValue = inspectable.grid.childCount
        self.gridRenderingButton.state = (inspectable.grid.isHidden ? .off : .on)
        
        guard let chunk = inspectable.chunk else { return }
        
        self.tileCountLabel.integerValue = chunk.childCount
        self.chunkRenderingButton.state = (chunk.isHidden ? .off : .on)
        
        guard let tile = inspectable.tile else { return }
        
        self.edgeCountLabel.integerValue = tile.childCount
        self.tileRenderingButton.state = (tile.isHidden ? .off : .on)
        
        self.edgePopUp.removeAllItems()
        
        for cardinal in Cardinal.allCases {
            
            guard let edge = tile.find(edge: cardinal) else { continue }
            
            self.edgePopUp.addItem(withTitle: edge.cardinal.description)
        }
        
        guard let edge = inspectable.edge else { return }
        
        self.edgePopUp.selectItem(at: edge.cardinal.rawValue)
        
        self.layerCountLabel.integerValue = edge.childCount
        self.edgeRenderingButton.state = (edge.isHidden ? .off : .on)
        
        self.layerPopUp.removeAllItems()
        
        for index in 0..<edge.childCount {
            
            self.layerPopUp.addItem(withTitle: "Layer \(index)")
        }
        
        guard let layer = inspectable.layer else { return }
        
        self.layerPopUp.selectItem(at: edge.index(of: layer) ?? 0)
        
        self.layerRenderingButton.state = (layer.isHidden ? .off : .on)
        
        self.terrainTypePopUp.removeAllItems()
        
        for terrainType in TerrainType.allCases {
            
            self.terrainTypePopUp.addItem(withTitle: terrainType.description)
            
            self.terrainTypePopUp.item(at: terrainType.rawValue)?.set(color0: terrainType.primaryColor.color, color1: terrainType.secondaryColor.color)
        }
        
        self.terrainTypePopUp.selectItem(at: layer.terrainType.rawValue)
        
        self.leftCornerElevationStepper.integerValue = layer.get(elevation: .left)
        self.leftCornerElevationStepper.minValue = Double(layer.lower?.get(elevation: .left) ?? 0)
        self.leftCornerElevationStepper.maxValue = Double(layer.upper?.get(elevation: .left) ?? World.Constants.ceiling)
        
        self.rightCornerElevationStepper.integerValue = layer.get(elevation: .right)
        self.rightCornerElevationStepper.minValue = Double(layer.lower?.get(elevation: .right) ?? 0)
        self.rightCornerElevationStepper.maxValue = Double(layer.upper?.get(elevation: .right) ?? World.Constants.ceiling)
        
        self.centreCornerElevationStepper.integerValue = layer.get(elevation: .centre)
        self.centreCornerElevationStepper.minValue = Double(layer.lower?.get(elevation: .centre) ?? 0)
        self.centreCornerElevationStepper.maxValue = Double(layer.upper?.get(elevation: .centre) ?? World.Constants.ceiling)
        
        self.leftCornerElevationTextField.integerValue = self.leftCornerElevationStepper.integerValue
        self.rightCornerElevationTextField.integerValue = self.rightCornerElevationStepper.integerValue
        self.centreCornerElevationTextField.integerValue = self.centreCornerElevationStepper.integerValue
    }
}
