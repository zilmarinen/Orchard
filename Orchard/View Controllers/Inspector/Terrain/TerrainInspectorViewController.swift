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
        
        switch viewModel.state {
            
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
                
            case layerHiddenButton:
                
                guard let layer = inspectable.layer else { break }
                
                layer.isHidden = sender.state == .off
             
            default: break
            }
            
            viewModel.state = .terrain(editor: editor, inspectable: inspectable)
            
        default: break
        }
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .terrain(let editor, let inspectable):
            
            switch sender {
                
            case selectedNodePopUp:
                
                guard let tile = inspectable.tile, let node = tile.child(at: sender.indexOfSelectedItem), let edge = node.child(at: 0), let layer = edge.child(at: 0) else { break }
                
                viewModel.state = .terrain(editor: editor,inspectable: (inspectable.grid, inspectable.chunk, tile, node, edge, layer))
                
                editor.delegate.sceneGraph(didSelectChild: node, atIndex: sender.indexOfSelectedItem)
                
            case selectedEdgePopUp:
                
                guard let gridEdge = GridEdge(rawValue: sender.indexOfSelectedItem), let edge = inspectable.node?.find(edge: gridEdge) else { break }
                
                viewModel.state = .terrain(editor: editor, inspectable: (inspectable.grid, inspectable.chunk, inspectable.tile, inspectable.node, edge, edge.child(at: 0)))
                
            case selectedLayerPopUp:
                
                guard let layer = inspectable.edge?.child(at: sender.indexOfSelectedItem) else { break }
                
                viewModel.state = .terrain(editor: editor, inspectable: (inspectable.grid, inspectable.chunk, inspectable.tile, inspectable.node, inspectable.edge, layer))
                
            case selectedTerrainTypePopUp:
                
                guard let layer = inspectable.layer, let terrainType = TerrainType(rawValue: sender.indexOfSelectedItem) else { break }
                
                layer.terrainType = terrainType
                
                viewModel.state = .terrain(editor: editor, inspectable: inspectable)
                
            default: break
            }
            
        default: break
        }
    }
    
    @IBAction func stepper(_ sender: NSStepper) {
        
        switch viewModel.state {
            
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
            
            viewModel.state = .terrain(editor: editor, inspectable: inspectable)
            
        default: break
        }
    }
    
    @IBAction func textField(_ sender: NSTextField) {
        
        switch viewModel.state {
            
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
            
            viewModel.state = .terrain(editor: editor, inspectable: inspectable)
            
        default: break
        }
    }
    
    lazy var viewModel = {
        
        return TerrainInspectorViewModel(initialState: .empty)
    }()
}

extension TerrainInspectorViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension TerrainInspectorViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .terrain(_, let inspectable):
            
            chunkCount.integerValue = inspectable.grid.totalChildren
            gridHiddenButton.state = (inspectable.grid.isHidden ? .off : .on)
            
            chunkBox.isHidden = true
            tileBox.isHidden = true
            nodeBox.isHidden = true
            edgeBox.isHidden = true
            layerBox.isHidden = true
            
            selectedNodePopUp.removeAllItems()
            selectedEdgePopUp.removeAllItems()
            selectedTerrainTypePopUp.removeAllItems()
            
            if let chunk = inspectable.chunk, let tile = inspectable.tile, let node = inspectable.node, let edge = inspectable.edge, let layer = inspectable.layer {
                
                let (c0, c1) = GridCorner.corners(edge: layer.edge)
                
                chunkBox.isHidden = inspectable.grid.isHidden
                tileBox.isHidden = inspectable.grid.isHidden || chunk.isHidden
                nodeBox.isHidden = inspectable.grid.isHidden || chunk.isHidden || tile.isHidden
                edgeBox.isHidden = inspectable.grid.isHidden || chunk.isHidden || tile.isHidden || node.isHidden
                layerBox.isHidden = inspectable.grid.isHidden || chunk.isHidden || tile.isHidden || node.isHidden || layer.isHidden
                
                tileCount.integerValue = chunk.totalChildren
                layerCount.integerValue = edge.totalChildren
                chunkHiddenButton.state = (chunk.isHidden ? .off : .on)
                tileHiddenButton.state = (tile.isHidden ? .off : .on)
                nodeHiddenButton.state = (node.isHidden ? .off : .on)
                edgeHiddenButton.state = (node.isHidden ? .off : .on)
                layerHiddenButton.state = (layer.isHidden ? .off : .on)
                
                xTileCoordinateLabel.integerValue = tile.volume.coordinate.x
                yTileCoordinateLabel.integerValue = tile.volume.coordinate.y
                zTileCoordinateLabel.integerValue = tile.volume.coordinate.z
                
                for index in 0..<tile.totalChildren {
                    
                    selectedNodePopUp.addItem(withTitle: "Node \(index + 1)")
                }
                
                if let index = tile.index(of: node) {
                    
                    selectedNodePopUp.selectItem(at: index)
                }
                
                xNodeCoordinateLabel.integerValue = node.volume.coordinate.x
                yNodeCoordinateLabel.integerValue = node.volume.coordinate.y
                zNodeCoordinateLabel.integerValue = node.volume.coordinate.z
                widthNodeSizeLabel.integerValue = node.volume.size.width
                heightNodeSizeLabel.integerValue = node.volume.size.height
                depthNodeSizeLabel.integerValue = node.volume.size.depth
                
                for index in 0..<node.totalChildren {
                    
                    selectedLayerPopUp.addItem(withTitle: "Layer \(index + 1)")
                }
                
                if let index = edge.index(of: layer) {
                    
                    selectedLayerPopUp.selectItem(at: index)
                }
                
                upperCorner0Stepper.maxValue = Double(layer.upper?.get(corner: c0) ?? World.ceiling)
                upperCorner0Stepper.minValue = Double(layer.lower?.get(corner: c0) ?? World.floor)
                upperCorner0Stepper.integerValue = (layer.get(corner: c0) ?? World.floor)
                
                upperCorner1Stepper.maxValue = Double(layer.upper?.get(corner: c1) ?? World.ceiling)
                upperCorner1Stepper.minValue = Double(layer.lower?.get(corner: c1) ?? World.floor)
                upperCorner1Stepper.integerValue = (layer.get(corner: c1) ?? World.floor)
                
                upperCentreStepper.maxValue = Double(layer.upper?.centre ?? World.ceiling)
                upperCentreStepper.minValue = Double(layer.lower?.centre ?? World.floor)
                upperCentreStepper.integerValue = layer.centre
                
                upperCorner0TextField.integerValue = upperCorner0Stepper.integerValue
                upperCorner1TextField.integerValue = upperCorner1Stepper.integerValue
                upperCentreTextField.integerValue = upperCentreStepper.integerValue
                
                lowerCorner0TextField.integerValue = (layer.lower?.get(corner: c0) ?? World.floor)
                lowerCorner1TextField.integerValue = (layer.lower?.get(corner: c1) ?? World.floor)
                lowerCentreTextField.integerValue = (layer.lower?.centre ?? World.floor)
                
                GridEdge.Edges.forEach { edge in
                    
                    selectedEdgePopUp.addItem(withTitle: edge.description)
                }
                
                TerrainType.allCases.forEach { terrainType in
                    
                    selectedTerrainTypePopUp.addItem(withTitle: terrainType.name)
                }
                
                if let index = GridEdge.Edges.index(of: layer.edge) {
                    
                    selectedEdgePopUp.selectItem(at: index)
                }
                
                if let index = TerrainType.allCases.index(of: layer.terrainType), let colorPalette = layer.terrainType.colorPalette {
                    
                    selectedTerrainTypePopUp.selectItem(at: index)
                    
                    terrainTypeColorPaletteView.colorPalette = colorPalette
                }
                else {
                    
                    terrainTypeColorPaletteView.colorPalette = nil
                }
            }
            
        default: break
        }
    }
}
