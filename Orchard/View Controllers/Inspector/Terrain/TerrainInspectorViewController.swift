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
    @IBOutlet weak var layerBox: NSBox!
    
    @IBOutlet weak var chunkCount: NSTextField!
    @IBOutlet weak var tileCount: NSTextField!
    
    @IBOutlet weak var gridHiddenButton: NSButton!
    @IBOutlet weak var chunkHiddenButton: NSButton!
    @IBOutlet weak var tileHiddenButton: NSButton!
    @IBOutlet weak var nodeHiddenButton: NSButton!
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
    
    @IBOutlet weak var selectedLayerPopUp: NSPopUpButton!
    
    @IBOutlet weak var upperNorthWestLayerCornerLabel: NSTextField!
    @IBOutlet weak var upperNorthEastLayerCornerLabel: NSTextField!
    @IBOutlet weak var upperSouthEastLayerCornerLabel: NSTextField!
    @IBOutlet weak var upperSouthWestLayerCornerLabel: NSTextField!
    
    @IBOutlet weak var lowerNorthWestLayerCornerLabel: NSTextField!
    @IBOutlet weak var lowerNorthEastLayerCornerLabel: NSTextField!
    @IBOutlet weak var lowerSouthEastLayerCornerLabel: NSTextField!
    @IBOutlet weak var lowerSouthWestLayerCornerLabel: NSTextField!
    
    @IBOutlet weak var northWestLayerCornerStepper: NSStepper!
    @IBOutlet weak var northEastLayerCornerStepper: NSStepper!
    @IBOutlet weak var southEastLayerCornerStepper: NSStepper!
    @IBOutlet weak var southWestLayerCornerStepper: NSStepper!
    
    @IBOutlet weak var selectedEdgePopup: NSPopUpButton!
    @IBOutlet weak var selectedTerrainTypePopup: NSPopUpButton!
    
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
                
                guard let tile = inspectable.tile, let selectedNode = tile.child(at: sender.indexOfSelectedItem) as? TerrainNode, let selectedLayer = selectedNode.child(at: 0) as? TerrainLayer else { break }
                
                viewModel.state = .terrain(editor: editor,inspectable: (inspectable.grid, inspectable.chunk, tile, selectedNode, selectedLayer, inspectable.edge))
                
                editor.delegate.sceneGraph(didSelectChild: selectedNode, atIndex: sender.indexOfSelectedItem)
                
            case selectedLayerPopUp:
                
                guard let node = inspectable.node, let selectedLayer = node.child(at: sender.indexOfSelectedItem) as? TerrainLayer else { break }
                
                viewModel.state = .terrain(editor: editor, inspectable: (inspectable.grid, inspectable.chunk, inspectable.tile, node, selectedLayer, inspectable.edge))
                
                editor.delegate.sceneGraph(didSelectChild: selectedLayer, atIndex: sender.indexOfSelectedItem)
                
            case selectedEdgePopup:
                
                guard let selectedEdge = GridEdge(rawValue: sender.indexOfSelectedItem) else { break }
                
                viewModel.state = .terrain(editor: editor, inspectable: (inspectable.grid, inspectable.chunk, inspectable.tile, inspectable.node, inspectable.layer, selectedEdge))
                
            case selectedTerrainTypePopup:
                
                guard let layer = inspectable.layer, let selectedTerrainType = TerrainType(rawValue: sender.indexOfSelectedItem), let edge = GridEdge(rawValue: selectedEdgePopup.indexOfSelectedItem) else { break }
                
                layer.set(terrainType: selectedTerrainType, edge: edge)
                
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
            
            switch sender {
                
            case northWestLayerCornerStepper:
                
                layer.set(height: sender.integerValue, corner: .northWest)
                
            case northEastLayerCornerStepper:
                
                layer.set(height: sender.integerValue, corner: .northEast)
                
            case southEastLayerCornerStepper:
                
                layer.set(height: sender.integerValue, corner: .southEast)
                
            case southWestLayerCornerStepper:
                
                layer.set(height: sender.integerValue, corner: .southWest)
            
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
            
            switch sender {
                
            case upperNorthWestLayerCornerLabel:
                
                layer.set(height: sender.integerValue, corner: .northWest)
                
            case upperNorthEastLayerCornerLabel:
                
                layer.set(height: sender.integerValue, corner: .northEast)
                
            case upperSouthEastLayerCornerLabel:
                
                layer.set(height: sender.integerValue, corner: .southEast)
                
            case upperSouthWestLayerCornerLabel:
                
                layer.set(height: sender.integerValue, corner: .southWest)
                
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
        
        viewModel.subscribe(stateDidChange)
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
            layerBox.isHidden = true
            
            selectedNodePopUp.removeAllItems()
            selectedLayerPopUp.removeAllItems()
            selectedEdgePopup.removeAllItems()
            selectedTerrainTypePopup.removeAllItems()
            
            if let chunk = inspectable.chunk, let tile = inspectable.tile, let node = inspectable.node, let layer = inspectable.layer {
                
                chunkBox.isHidden = inspectable.grid.isHidden
                tileBox.isHidden = inspectable.grid.isHidden || chunk.isHidden
                nodeBox.isHidden = inspectable.grid.isHidden || chunk.isHidden || tile.isHidden
                layerBox.isHidden = inspectable.grid.isHidden || chunk.isHidden || tile.isHidden || node.isHidden
                
                tileCount.integerValue = chunk.totalChildren
                chunkHiddenButton.state = (chunk.isHidden ? .off : .on)
                tileHiddenButton.state = (tile.isHidden ? .off : .on)
                nodeHiddenButton.state = (node.isHidden ? .off : .on)
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
                
                if let index = node.index(of: layer) {
                    
                    selectedLayerPopUp.selectItem(at: index)
                }
                
                northWestLayerCornerStepper.maxValue = Double(layer.hierarchy.upper?.get(height: .northWest) ?? World.ceiling)
                northWestLayerCornerStepper.minValue = Double(layer.hierarchy.lower?.get(height: .northWest) ?? World.floor)
                northWestLayerCornerStepper.integerValue = layer.get(height: .northWest)
                
                northEastLayerCornerStepper.maxValue = Double(layer.hierarchy.upper?.get(height: .northEast) ?? World.ceiling)
                northEastLayerCornerStepper.minValue = Double(layer.hierarchy.lower?.get(height: .northEast) ?? World.floor)
                northEastLayerCornerStepper.integerValue = layer.get(height: .northEast)
                
                southEastLayerCornerStepper.maxValue = Double(layer.hierarchy.upper?.get(height: .southEast) ?? World.ceiling)
                southEastLayerCornerStepper.minValue = Double(layer.hierarchy.lower?.get(height: .southEast) ?? World.floor)
                southEastLayerCornerStepper.integerValue = layer.get(height: .southEast)
                
                southWestLayerCornerStepper.maxValue = Double(layer.hierarchy.upper?.get(height: .southWest) ?? World.ceiling)
                southWestLayerCornerStepper.minValue = Double(layer.hierarchy.lower?.get(height: .southWest) ?? World.floor)
                southWestLayerCornerStepper.integerValue = layer.get(height: .southWest)
                
                upperNorthWestLayerCornerLabel.integerValue = northWestLayerCornerStepper.integerValue
                upperNorthEastLayerCornerLabel.integerValue = northEastLayerCornerStepper.integerValue
                upperSouthEastLayerCornerLabel.integerValue = southEastLayerCornerStepper.integerValue
                upperSouthWestLayerCornerLabel.integerValue = southWestLayerCornerStepper.integerValue
                
                lowerNorthWestLayerCornerLabel.integerValue = (layer.hierarchy.lower?.get(height: .northWest) ?? World.floor)
                lowerNorthEastLayerCornerLabel.integerValue = (layer.hierarchy.lower?.get(height: .northEast) ?? World.floor)
                lowerSouthEastLayerCornerLabel.integerValue = (layer.hierarchy.lower?.get(height: .southEast) ?? World.floor)
                lowerSouthWestLayerCornerLabel.integerValue = (layer.hierarchy.lower?.get(height: .southWest) ?? World.floor)
                
                GridEdge.Edges.forEach { edge in
                    
                    selectedEdgePopup.addItem(withTitle: edge.description)
                }
                
                TerrainType.allCases.forEach { terrainType in
                    
                    selectedTerrainTypePopup.addItem(withTitle: terrainType.name)
                }
                
                if let index = GridEdge.Edges.index(of: inspectable.edge) {
                    
                    selectedEdgePopup.selectItem(at: index)
                }
                
                let terrainType = layer.get(terrainType: inspectable.edge)
                
                if let index = TerrainType.allCases.index(of: terrainType), let colorPalette = terrainType.colorPalette {
                    
                    selectedTerrainTypePopup.selectItem(at: index)
                    
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
