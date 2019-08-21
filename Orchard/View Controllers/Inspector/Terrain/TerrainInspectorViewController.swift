//
//  TerrainInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 19/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import SceneKit

class TerrainInspectorViewController: NSViewController {
    
    @IBOutlet weak var chunkBox: NSBox!
    @IBOutlet weak var tileBox: NSBox!
    @IBOutlet weak var nodeBox: NSBox!
    @IBOutlet weak var edgeBox: NSBox!
    @IBOutlet weak var layerBox: NSBox!
    
    @IBOutlet weak var chunkCount: NSTextField!
    @IBOutlet weak var tileCount: NSTextField!
    @IBOutlet weak var edgeCount: NSTextField!
    @IBOutlet weak var layerCount: NSTextField!
    
    @IBOutlet weak var gridHiddenButton: NSButton!
    @IBOutlet weak var chunkHiddenButton: NSButton!
    @IBOutlet weak var tileHiddenButton: NSButton!
    @IBOutlet weak var nodeHiddenButton: NSButton!
    @IBOutlet weak var edgeHiddenButton: NSButton!
    @IBOutlet weak var layerHiddenButton: NSButton!
    
    @IBOutlet weak var xTileCoordinateLabel: NSTextField!
    @IBOutlet weak var yTileCoordinateLabel: NSTextField!
    @IBOutlet weak var zTileCoordinateLabel: NSTextField!
    
    @IBOutlet weak var selectedNodePopUp: NSPopUpButton!
    
    @IBOutlet weak var sceneView: InspectorSceneView!
    
    @IBOutlet weak var xNodeCoordinateLabel: NSTextField!
    @IBOutlet weak var yNodeCoordinateLabel: NSTextField!
    @IBOutlet weak var zNodeCoordinateLabel: NSTextField!
    @IBOutlet weak var widthNodeSizeLabel: NSTextField!
    @IBOutlet weak var heightNodeSizeLabel: NSTextField!
    @IBOutlet weak var depthNodeSizeLabel: NSTextField!
    
    @IBOutlet weak var selectedEdgePopUp: NSPopUpButton!
    @IBOutlet weak var selectedLayerPopUp: NSPopUpButton!
    
    @IBOutlet weak var upperCorner0Label: NSTextField!
    @IBOutlet weak var upperCorner1Label: NSTextField!
    @IBOutlet weak var upperCorner0TextField: NSTextField!
    @IBOutlet weak var upperCorner1TextField: NSTextField!
    @IBOutlet weak var upperCentreTextField: NSTextField!
    
    @IBOutlet weak var lowerCorner0Label: NSTextField!
    @IBOutlet weak var lowerCorner1Label: NSTextField!
    @IBOutlet weak var lowerCorner0TextField: NSTextField!
    @IBOutlet weak var lowerCorner1TextField: NSTextField!
    @IBOutlet weak var lowerCentreTextField: NSTextField!
    
    @IBOutlet weak var upperCorner0Stepper: NSStepper!
    @IBOutlet weak var upperCorner1Stepper: NSStepper!
    @IBOutlet weak var upperCentreStepper: NSStepper!
    
    @IBOutlet weak var selectedTerrainTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var terrainTypeColorPaletteView: ColorPaletteView!
    
    @IBAction func button(_ sender: NSButton) {
        
        switch stateObserver.state {
            
        case .terrain(let editor, let inspectable):
            
            switch sender {
                
            case gridHiddenButton:
                
                inspectable.grid.isHidden = sender.state == .off
                
            case chunkHiddenButton:
                
                guard let chunk = inspectable.chunk else { break }
                
                chunk.isHidden = sender.state == .off
                
            case tileHiddenButton:
                
                guard let tile = inspectable.tile else { break }
                
                tile.isHidden = sender.state == .off
                
            case nodeHiddenButton:
                
                guard let node = inspectable.node else { break }
                
                node.isHidden = sender.state == .off
                
            case edgeHiddenButton:
                
                guard let edge = inspectable.edge else { break }
                
                edge.isHidden = sender.state == .off
                
            case layerHiddenButton:
                
                guard let layer = inspectable.layer else { break }
                
                layer.isHidden = sender.state == .off
             
            default: break
            }
            
            stateObserver.state = .terrain(editor: editor, inspectable: inspectable)
            
        default: break
        }
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch stateObserver.state {
            
        case .terrain(let editor, let inspectable):
            
            switch sender {
                
            case selectedNodePopUp:
                
                guard let tile = inspectable.tile, let node = tile.child(at: sender.indexOfSelectedItem) as? TerrainNode, let edge = node.child(at: 0) as? TerrainNodeEdge else { break }
                
                stateObserver.state = .terrain(editor: editor,inspectable: (inspectable.grid, inspectable.chunk, tile, node, edge, edge.child(at: 0) as? TerrainNodeEdgeLayer))
                
                editor.delegate.sceneGraph(didSelectChild: node, atIndex: sender.indexOfSelectedItem)
                
            case selectedEdgePopUp:
                
                guard let gridEdge = GridEdge(rawValue: sender.indexOfSelectedItem), let edge = inspectable.node?.find(edge: gridEdge) else { break }
                
                stateObserver.state = .terrain(editor: editor, inspectable: (inspectable.grid, inspectable.chunk, inspectable.tile, inspectable.node, edge, edge.child(at: 0) as? TerrainNodeEdgeLayer))
                
            case selectedLayerPopUp:
                
                guard let layer = inspectable.edge?.child(at: sender.indexOfSelectedItem) as? TerrainNodeEdgeLayer else { break }
                
                stateObserver.state = .terrain(editor: editor, inspectable: (inspectable.grid, inspectable.chunk, inspectable.tile, inspectable.node, inspectable.edge, layer))
                
            case selectedTerrainTypePopUp:
                
                guard let layer = inspectable.layer, let terrainType = TerrainType(rawValue: sender.indexOfSelectedItem) else { break }
                
                layer.terrainType = terrainType
                
                stateObserver.state = .terrain(editor: editor, inspectable: inspectable)
                
            default: break
            }
            
        default: break
        }
    }
    
    @IBAction func stepper(_ sender: NSStepper) {
        
        switch stateObserver.state {
            
        case .terrain(let editor, let inspectable):
            
            guard let layer = inspectable.layer else { break }
            
            let (c0, c1) = GridCorner.corners(edge: layer.edge)
            
            switch sender {
                
            case upperCorner0Stepper:
                
                layer.set(corner: c0, height: sender.integerValue)
                
            case upperCorner1Stepper:
                
                layer.set(corner: c1, height: sender.integerValue)
                
            case upperCentreStepper:
                
                layer.set(center: sender.integerValue)
            
            default: break
            }
            
            stateObserver.state = .terrain(editor: editor, inspectable: inspectable)
            
        default: break
        }
    }
    
    @IBAction func textField(_ sender: NSTextField) {
        
        switch stateObserver.state {
            
        case .terrain(let editor, let inspectable):
            
            guard let layer = inspectable.layer else { break }
            
            let (c0, c1) = GridCorner.corners(edge: layer.edge)
            
            switch sender {
                
            case upperCorner0TextField:
                
                layer.set(corner: c0, height: sender.integerValue)
                
            case upperCorner1TextField:
                
                layer.set(corner: c1, height: sender.integerValue)
                
            case upperCentreTextField:
                
                layer.set(center: sender.integerValue)
                
            default: break
            }
            
            stateObserver.state = .terrain(editor: editor, inspectable: inspectable)
            
        default: break
        }
    }
    
    lazy var stateObserver = {
        
        return TerrainInspectorStateObserver(initialState: .empty)
    }()
}

extension TerrainInspectorViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        stateObserver.subscribe(stateDidChange(from:to:))
    }
}

extension TerrainInspectorViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
            
            switch to {
                
            case .terrain(_, let inspectable):
                
                self.chunkCount.integerValue = inspectable.grid.totalChildren
                self.gridHiddenButton.state = (inspectable.grid.isHidden ? .off : .on)
                
                self.chunkBox.isHidden = true
                self.tileBox.isHidden = true
                self.nodeBox.isHidden = true
                self.edgeBox.isHidden = true
                self.layerBox.isHidden = true
                
                self.selectedNodePopUp.removeAllItems()
                self.selectedEdgePopUp.removeAllItems()
                self.selectedLayerPopUp.removeAllItems()
                self.selectedTerrainTypePopUp.removeAllItems()
                
                if let chunk = inspectable.chunk, let tile = inspectable.tile, let node = inspectable.node {
                    
                    self.chunkBox.isHidden = inspectable.grid.isHidden
                    self.tileBox.isHidden = inspectable.grid.isHidden || chunk.isHidden
                    self.nodeBox.isHidden = inspectable.grid.isHidden || chunk.isHidden || tile.isHidden
                    self.edgeBox.isHidden = inspectable.grid.isHidden || chunk.isHidden || tile.isHidden || node.isHidden
                    self.layerBox.isHidden = inspectable.edge == nil || inspectable.layer == nil
                    
                    self.tileCount.integerValue = chunk.totalChildren
                    self.edgeCount.integerValue = node.totalChildren
                    self.chunkHiddenButton.state = (chunk.isHidden ? .off : .on)
                    self.tileHiddenButton.state = (tile.isHidden ? .off : .on)
                    self.nodeHiddenButton.state = (node.isHidden ? .off : .on)
                    
                    self.xTileCoordinateLabel.integerValue = tile.volume.coordinate.x
                    self.yTileCoordinateLabel.integerValue = tile.volume.coordinate.y
                    self.zTileCoordinateLabel.integerValue = tile.volume.coordinate.z
                    
                    for index in 0..<tile.totalChildren {
                        
                        self.selectedNodePopUp.addItem(withTitle: "Node \(index + 1)")
                    }
                    
                    if let index = tile.index(of: node) {
                        
                        self.selectedNodePopUp.selectItem(at: index)
                    }
                    
                    self.xNodeCoordinateLabel.integerValue = node.volume.coordinate.x
                    self.yNodeCoordinateLabel.integerValue = node.volume.coordinate.y
                    self.zNodeCoordinateLabel.integerValue = node.volume.coordinate.z
                    self.widthNodeSizeLabel.integerValue = node.volume.size.width
                    self.heightNodeSizeLabel.integerValue = node.volume.size.height
                    self.depthNodeSizeLabel.integerValue = node.volume.size.depth
                    
                    for index in 0..<node.totalChildren {
                        
                        if let nodeEdge = node.child(at: index) as? TerrainNodeEdge {
                        
                            self.selectedEdgePopUp.addItem(withTitle: nodeEdge.edge.description)
                        }
                    }
                    
                    guard let edge = inspectable.edge, let layer = inspectable.layer else { break }
                    
                    self.edgeHiddenButton.state = (edge.isHidden ? .off : .on)
                    self.layerCount.integerValue = edge.totalChildren
                    
                    if let index = node.index(of: edge) {
                        
                        self.selectedEdgePopUp.selectItem(at: index)
                    }
                    
                    self.layerBox.isHidden = inspectable.grid.isHidden || chunk.isHidden || tile.isHidden || node.isHidden || edge.isHidden
                    self.layerHiddenButton.state = (layer.isHidden ? .off : .on)
                    
                    for index in 0..<edge.totalChildren {
                        
                        self.selectedLayerPopUp.addItem(withTitle: "Layer \(index + 1)")
                    }
                    
                    if let index = edge.index(of: layer) {
                        
                        self.selectedLayerPopUp.selectItem(at: index)
                    }
                    
                    let (c0, c1) = GridCorner.corners(edge: layer.edge)
                    
                    self.upperCorner0Stepper.maxValue = Double(layer.upper?.get(corner: c0) ?? World.ceiling)
                    self.upperCorner0Stepper.minValue = Double(layer.lower?.get(corner: c0) ?? World.floor)
                    self.upperCorner0Stepper.integerValue = (layer.get(corner: c0) ?? World.floor)
                    
                    self.upperCorner1Stepper.maxValue = Double(layer.upper?.get(corner: c1) ?? World.ceiling)
                    self.upperCorner1Stepper.minValue = Double(layer.lower?.get(corner: c1) ?? World.floor)
                    self.upperCorner1Stepper.integerValue = (layer.get(corner: c1) ?? World.floor)
                    
                    self.upperCentreStepper.maxValue = Double(layer.upper?.centre ?? World.ceiling)
                    self.upperCentreStepper.minValue = Double(layer.lower?.centre ?? World.floor)
                    self.upperCentreStepper.integerValue = layer.centre
                    
                    self.upperCorner0TextField.integerValue = self.upperCorner0Stepper.integerValue
                    self.upperCorner1TextField.integerValue = self.upperCorner1Stepper.integerValue
                    self.upperCentreTextField.integerValue = self.upperCentreStepper.integerValue
                    
                    self.lowerCorner0TextField.integerValue = (layer.lower?.get(corner: c0) ?? World.floor)
                    self.lowerCorner1TextField.integerValue = (layer.lower?.get(corner: c1) ?? World.floor)
                    self.lowerCentreTextField.integerValue = (layer.lower?.centre ?? World.floor)
                    
                    TerrainType.allCases.forEach { terrainType in
                        
                        self.selectedTerrainTypePopUp.addItem(withTitle: terrainType.name)
                    }
                    
                    if let index = TerrainType.allCases.firstIndex(of: layer.terrainType), let colorPalette = layer.terrainType.colorPalette {
                        
                        self.selectedTerrainTypePopUp.selectItem(at: index)
                        
                        self.terrainTypeColorPaletteView.colorPalette = colorPalette
                    }
                    else {
                        
                        self.terrainTypeColorPaletteView.colorPalette = nil
                    }
                }
                
            default: break
            }
        }
    }
}
