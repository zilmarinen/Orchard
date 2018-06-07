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
    
    @IBOutlet weak var smoothTerraformButton: NSButton!
    
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
    
    @IBOutlet weak var northLayerEdgeTerrainTypePopUp: NSPopUpButton!
    @IBOutlet weak var eastLayerEdgeTerrainTypePopUp: NSPopUpButton!
    @IBOutlet weak var southLayerEdgeTerrainTypePopUp: NSPopUpButton!
    @IBOutlet weak var westLayerEdgeTerrainTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var northLayerEdgeTerrainTypeColorPalettePrimary: NSBox!
    @IBOutlet weak var northLayerEdgeTerrainTypeColorPaletteSecondary: NSBox!
    @IBOutlet weak var northLayerEdgeTerrainTypeColorPaletteTertiary: NSBox!
    @IBOutlet weak var northLayerEdgeTerrainTypeColorPaletteQuaternary: NSBox!
    
    @IBOutlet weak var eastLayerEdgeTerrainTypeColorPalettePrimary: NSBox!
    @IBOutlet weak var eastLayerEdgeTerrainTypeColorPaletteSecondary: NSBox!
    @IBOutlet weak var eastLayerEdgeTerrainTypeColorPaletteTertiary: NSBox!
    @IBOutlet weak var eastLayerEdgeTerrainTypeColorPaletteQuaternary: NSBox!
    
    @IBOutlet weak var southLayerEdgeTerrainTypeColorPalettePrimary: NSBox!
    @IBOutlet weak var southLayerEdgeTerrainTypeColorPaletteSecondary: NSBox!
    @IBOutlet weak var southLayerEdgeTerrainTypeColorPaletteTertiary: NSBox!
    @IBOutlet weak var southLayerEdgeTerrainTypeColorPaletteQuaternary: NSBox!
    
    @IBOutlet weak var westLayerEdgeTerrainTypeColorPalettePrimary: NSBox!
    @IBOutlet weak var westLayerEdgeTerrainTypeColorPaletteSecondary: NSBox!
    @IBOutlet weak var westLayerEdgeTerrainTypeColorPaletteTertiary: NSBox!
    @IBOutlet weak var westLayerEdgeTerrainTypeColorPaletteQuaternary: NSBox!
    
    @IBAction func button(_ sender: NSButton) {
        
        switch viewModel.state {
            
        case .inspecting(let grid, let inspectable, var smooth):
            
            switch sender {
                
            case gridHiddenButton:
                
                grid.isHidden = sender.state == .off
                
            case chunkHiddenButton:
                
                guard let (chunk, _, _, _) = inspectable else { break }
                
                chunk.isHidden = sender.state == .off
                
            case tileHiddenButton:
                
                guard let (_, tile, _, _) = inspectable else { break }
                
                tile.isHidden = sender.state == .off
                
            case nodeHiddenButton:
                
                guard let (_, _, node, _) = inspectable else { break }
                
                node.isHidden = sender.state == .off
                
            case layerHiddenButton:
                
                guard let (_, _, _, layer) = inspectable else { break }
                
                layer.isHidden = sender.state == .off
                
            case smoothTerraformButton:
                
                smooth = sender.state == .on
             
            default: break
            }
            
            viewModel.state = .inspecting(grid, inspectable, smooth)
            
        default: break
        }
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .inspecting(let grid, let inspectable, let smooth):
            
            guard let (chunk, tile, node, layer) = inspectable else { break }
            
            switch sender {
                
            case selectedNodePopUp:
                
                guard let selectedNode = tile.sceneGraph(childAtIndex: sender.indexOfSelectedItem) as? TerrainNode, let selectedLayer = selectedNode.sceneGraph(childAtIndex: 0) as? TerrainLayer else { break }
                
                viewModel.state = .inspecting(grid, (chunk, tile, selectedNode, selectedLayer), smooth)
                
            case selectedLayerPopUp:
                
                guard let selectedLayer = node.sceneGraph(childAtIndex: sender.indexOfSelectedItem) as? TerrainLayer else { break }
                
                viewModel.state = .inspecting(grid, (chunk, tile, node, selectedLayer), smooth)
                
            case northLayerEdgeTerrainTypePopUp,
                 eastLayerEdgeTerrainTypePopUp,
                 southLayerEdgeTerrainTypePopUp,
                 westLayerEdgeTerrainTypePopUp:
                
                let selectedTerrainType = grid.availableTerrainTypes[sender.indexOfSelectedItem]
                
                switch sender {
                    
                case northLayerEdgeTerrainTypePopUp:
                    
                    layer.set(terrainType: selectedTerrainType, edge: .north)
                    
                case eastLayerEdgeTerrainTypePopUp:
                    
                    layer.set(terrainType: selectedTerrainType, edge: .east)
                    
                case southLayerEdgeTerrainTypePopUp:
                    
                    layer.set(terrainType: selectedTerrainType, edge: .south)
                    
                case westLayerEdgeTerrainTypePopUp:
                    
                    layer.set(terrainType: selectedTerrainType, edge: .west)
                    
                default: break
                }
                
                viewModel.state = .inspecting(grid, inspectable, smooth)
                
            default: break
            }
            
        default: break
        }
    }
    
    @IBAction func stepper(_ sender: NSStepper) {
        
        switch viewModel.state {
            
        case .inspecting(let grid, let inspectable, let smooth):
            
            guard let (_, _, _, layer) = inspectable else { break }
            
            switch sender {
                
            case northWestLayerCornerStepper:
                
                layer.set(height: sender.integerValue, corner: .northWest, smooth: smooth)
                
            case northEastLayerCornerStepper:
                
                layer.set(height: sender.integerValue, corner: .northEast, smooth: smooth)
                
            case southEastLayerCornerStepper:
                
                layer.set(height: sender.integerValue, corner: .southEast, smooth: smooth)
                
            case southWestLayerCornerStepper:
                
                layer.set(height: sender.integerValue, corner: .southWest, smooth: smooth)
            
            default: break
            }
            
            viewModel.state = .inspecting(grid, inspectable, smooth)
            
        default: break
        }
    }
    
    @IBAction func textField(_ sender: NSTextField) {
        
        switch viewModel.state {
            
        case .inspecting(let grid, let inspectable, let smooth):
            
            guard let (_, _, _, layer) = inspectable else { break }
            
            switch sender {
                
            case upperNorthWestLayerCornerLabel:
                
                layer.set(height: sender.integerValue, corner: .northWest, smooth: smooth)
                
            case upperNorthEastLayerCornerLabel:
                
                layer.set(height: sender.integerValue, corner: .northEast, smooth: smooth)
                
            case upperSouthEastLayerCornerLabel:
                
                layer.set(height: sender.integerValue, corner: .southEast, smooth: smooth)
                
            case upperSouthWestLayerCornerLabel:
                
                layer.set(height: sender.integerValue, corner: .southWest, smooth: smooth)
                
            default: break
            }
            
            viewModel.state = .inspecting(grid, inspectable, smooth)
            
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
            
        case .inspecting(let grid, let inspectable, let smooth):
            
            chunkCount.integerValue = grid.totalChildren
            gridHiddenButton.state = (grid.isHidden ? .off : .on)
            
            chunkBox.isHidden = true
            tileBox.isHidden = true
            nodeBox.isHidden = true
            layerBox.isHidden = true
            
            selectedNodePopUp.removeAllItems()
            selectedLayerPopUp.removeAllItems()
            northLayerEdgeTerrainTypePopUp.removeAllItems()
            eastLayerEdgeTerrainTypePopUp.removeAllItems()
            southLayerEdgeTerrainTypePopUp.removeAllItems()
            westLayerEdgeTerrainTypePopUp.removeAllItems()
            
            if let (chunk, tile, node, layer) = inspectable {
                
                chunkBox.isHidden = grid.isHidden
                tileBox.isHidden = grid.isHidden || chunk.isHidden
                nodeBox.isHidden = grid.isHidden || chunk.isHidden || tile.isHidden
                layerBox.isHidden = grid.isHidden || chunk.isHidden || tile.isHidden || node.isHidden
                
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
                
                if let index = tile.sceneGraph(indexOf: node) {
                    
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
                
                if let index = node.sceneGraph(indexOf: layer) {
                    
                    selectedLayerPopUp.selectItem(at: index)
                }
                
                smoothTerraformButton.state = (smooth ? .on : .off)
                
                northWestLayerCornerStepper.maxValue = Double(layer.upper?.get(height: .northWest) ?? World.Ceiling)
                northWestLayerCornerStepper.minValue = Double(layer.lower?.get(height: .northWest) ?? World.Floor)
                northWestLayerCornerStepper.integerValue = layer.get(height: .northWest)
                
                northEastLayerCornerStepper.maxValue = Double(layer.upper?.get(height: .northEast) ?? World.Ceiling)
                northEastLayerCornerStepper.minValue = Double(layer.lower?.get(height: .northEast) ?? World.Floor)
                northEastLayerCornerStepper.integerValue = layer.get(height: .northEast)
                
                southEastLayerCornerStepper.maxValue = Double(layer.upper?.get(height: .southEast) ?? World.Ceiling)
                southEastLayerCornerStepper.minValue = Double(layer.lower?.get(height: .southEast) ?? World.Floor)
                southEastLayerCornerStepper.integerValue = layer.get(height: .southEast)
                
                southWestLayerCornerStepper.maxValue = Double(layer.upper?.get(height: .southWest) ?? World.Ceiling)
                southWestLayerCornerStepper.minValue = Double(layer.lower?.get(height: .southWest) ?? World.Floor)
                southWestLayerCornerStepper.integerValue = layer.get(height: .southWest)
                
                upperNorthWestLayerCornerLabel.integerValue = northWestLayerCornerStepper.integerValue
                upperNorthEastLayerCornerLabel.integerValue = northEastLayerCornerStepper.integerValue
                upperSouthEastLayerCornerLabel.integerValue = southEastLayerCornerStepper.integerValue
                upperSouthWestLayerCornerLabel.integerValue = southWestLayerCornerStepper.integerValue
                
                lowerNorthWestLayerCornerLabel.integerValue = (layer.lower?.get(height: .northWest) ?? World.Floor)
                lowerNorthEastLayerCornerLabel.integerValue = (layer.lower?.get(height: .northEast) ?? World.Floor)
                lowerSouthEastLayerCornerLabel.integerValue = (layer.lower?.get(height: .southEast) ?? World.Floor)
                lowerSouthWestLayerCornerLabel.integerValue = (layer.lower?.get(height: .southWest) ?? World.Floor)
                
                grid.availableTerrainTypes.forEach { terrainType in
                    
                    northLayerEdgeTerrainTypePopUp.addItem(withTitle: terrainType.name)
                    eastLayerEdgeTerrainTypePopUp.addItem(withTitle: terrainType.name)
                    southLayerEdgeTerrainTypePopUp.addItem(withTitle: terrainType.name)
                    westLayerEdgeTerrainTypePopUp.addItem(withTitle: terrainType.name)
                }
                
                if let terrainLayerEdge = layer.get(terrainType: .north), let index = grid.availableTerrainTypes.index(of: terrainLayerEdge.terrainType) {
                    
                    northLayerEdgeTerrainTypePopUp.selectItem(at: index)
                    
                    northLayerEdgeTerrainTypeColorPalettePrimary.fillColor = terrainLayerEdge.terrainType.colorPalette.primary.color
                    northLayerEdgeTerrainTypeColorPaletteSecondary.fillColor = terrainLayerEdge.terrainType.colorPalette.secondary.color
                    northLayerEdgeTerrainTypeColorPaletteTertiary.fillColor = terrainLayerEdge.terrainType.colorPalette.tertiary.color
                    northLayerEdgeTerrainTypeColorPaletteQuaternary.fillColor = terrainLayerEdge.terrainType.colorPalette.quaternary.color
                }
                
                if let terrainLayerEdge = layer.get(terrainType: .east), let index = grid.availableTerrainTypes.index(of: terrainLayerEdge.terrainType) {
                    
                    eastLayerEdgeTerrainTypePopUp.selectItem(at: index)
                    
                    eastLayerEdgeTerrainTypeColorPalettePrimary.fillColor = terrainLayerEdge.terrainType.colorPalette.primary.color
                    eastLayerEdgeTerrainTypeColorPaletteSecondary.fillColor = terrainLayerEdge.terrainType.colorPalette.secondary.color
                    eastLayerEdgeTerrainTypeColorPaletteTertiary.fillColor = terrainLayerEdge.terrainType.colorPalette.tertiary.color
                    eastLayerEdgeTerrainTypeColorPaletteQuaternary.fillColor = terrainLayerEdge.terrainType.colorPalette.quaternary.color
                }
                
                if let terrainLayerEdge = layer.get(terrainType: .south), let index = grid.availableTerrainTypes.index(of: terrainLayerEdge.terrainType) {
                    
                    southLayerEdgeTerrainTypePopUp.selectItem(at: index)
                    
                    southLayerEdgeTerrainTypeColorPalettePrimary.fillColor = terrainLayerEdge.terrainType.colorPalette.primary.color
                    southLayerEdgeTerrainTypeColorPaletteSecondary.fillColor = terrainLayerEdge.terrainType.colorPalette.secondary.color
                    southLayerEdgeTerrainTypeColorPaletteTertiary.fillColor = terrainLayerEdge.terrainType.colorPalette.tertiary.color
                    southLayerEdgeTerrainTypeColorPaletteQuaternary.fillColor = terrainLayerEdge.terrainType.colorPalette.quaternary.color
                }
                
                if let terrainLayerEdge = layer.get(terrainType: .west), let index = grid.availableTerrainTypes.index(of: terrainLayerEdge.terrainType) {
                    
                    westLayerEdgeTerrainTypePopUp.selectItem(at: index)
                    
                    westLayerEdgeTerrainTypeColorPalettePrimary.fillColor = terrainLayerEdge.terrainType.colorPalette.primary.color
                    westLayerEdgeTerrainTypeColorPaletteSecondary.fillColor = terrainLayerEdge.terrainType.colorPalette.secondary.color
                    westLayerEdgeTerrainTypeColorPaletteTertiary.fillColor = terrainLayerEdge.terrainType.colorPalette.tertiary.color
                    westLayerEdgeTerrainTypeColorPaletteQuaternary.fillColor = terrainLayerEdge.terrainType.colorPalette.quaternary.color
                }
            }
            
        default: break
        }
    }
}
