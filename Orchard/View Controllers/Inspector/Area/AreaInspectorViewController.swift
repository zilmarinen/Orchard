//
//  AreaInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 19/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import SceneKit

class AreaInspectorViewController: NSViewController {
    
    @IBOutlet weak var chunkBox: NSBox!
    @IBOutlet weak var tileBox: NSBox!
    @IBOutlet weak var nodeBox: NSBox!
    
    @IBOutlet weak var chunkCount: NSTextField!
    @IBOutlet weak var tileCount: NSTextField!
    
    @IBOutlet weak var gridHiddenButton: NSButton!
    @IBOutlet weak var chunkHiddenButton: NSButton!
    @IBOutlet weak var tileHiddenButton: NSButton!
    @IBOutlet weak var nodeHiddenButton: NSButton!
    
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
    
    @IBOutlet weak var selectedSurfaceTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var surfaceTypecolorPalettePrimary: NSBox!
    @IBOutlet weak var surfaceTypecolorPaletteSecondary: NSBox!
    @IBOutlet weak var surfaceTypecolorPaletteTertiary: NSBox!
    @IBOutlet weak var surfaceTypecolorPaletteQuaternary: NSBox!
    
    @IBOutlet weak var selectedExternalPrefabTypePopUp: NSPopUpButton!
    @IBOutlet weak var selectedInternalPrefabTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var selectedNorthPerimeterTypePopUp: NSPopUpButton!
    @IBOutlet weak var selectedEastPerimeterTypePopUp: NSPopUpButton!
    @IBOutlet weak var selectedSouthPerimeterTypePopUp: NSPopUpButton!
    @IBOutlet weak var selectedWestPerimeterTypePopUp: NSPopUpButton!
    
    @IBAction func button(_ sender: NSButton) {
        
        switch viewModel.state {
            
        case .inspecting(let grid, let inspectable):
            
            switch sender {
                
            case gridHiddenButton:
                
                grid.isHidden = sender.state == .off
                
            case chunkHiddenButton:
                
                guard let (chunk, _, _) = inspectable else { break }
                
                chunk.isHidden = sender.state == .off
                
            case tileHiddenButton:
                
                guard let (_, tile, _) = inspectable else { break }
                
                tile.isHidden = sender.state == .off
                
            case nodeHiddenButton:
                
                guard let (_, _, node) = inspectable else { break }
                
                node.isHidden = sender.state == .off
                
            default: break
            }
            
            viewModel.state = .inspecting(grid, inspectable)
            
        default: break
        }
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .inspecting(let grid, let inspectable):
            
            guard let (chunk, tile, node) = inspectable else { break }
            
            switch sender {
                
            case selectedNodePopUp:
                
                guard let selectedNode = tile.sceneGraph(childAtIndex: sender.indexOfSelectedItem) as? AreaNode else { break }
                
                viewModel.state = .inspecting(grid, (chunk, tile, selectedNode))
                
            case selectedSurfaceTypePopUp:
                
                let selectedSurfaceType = grid.availableSurfaceTypes[sender.indexOfSelectedItem]
                
                node.surfaceType = selectedSurfaceType
                
                viewModel.state = .inspecting(grid, inspectable)
                
            case selectedExternalPrefabTypePopUp,
                 selectedInternalPrefabTypePopUp:
                
                let selectedPrefabType = AreaPrefabType.All[sender.indexOfSelectedItem]
                
                if sender == selectedExternalPrefabTypePopUp {
                 
                    node.externalPrefabType = selectedPrefabType
                }
                else {
                    
                    node.internalPrefabType = selectedPrefabType
                }
                
                viewModel.state = .inspecting(grid, inspectable)
                
            case selectedNorthPerimeterTypePopUp,
                 selectedEastPerimeterTypePopUp,
                 selectedSouthPerimeterTypePopUp,
                 selectedWestPerimeterTypePopUp:
                
                let selectedPerimeterIdentifier = AreaPerimeterType.Identifier.All[sender.indexOfSelectedItem]
                
                let perimeterType = AreaPerimeterType(identifier: selectedPerimeterIdentifier)
                
                switch sender {
                    
                case selectedNorthPerimeterTypePopUp:
                    
                    node.set(perimeterType: perimeterType, edge: .north)
                    
                case selectedEastPerimeterTypePopUp:
                    
                    node.set(perimeterType: perimeterType, edge: .east)
                    
                case selectedSouthPerimeterTypePopUp:
                    
                    node.set(perimeterType: perimeterType, edge: .south)
                    
                case selectedWestPerimeterTypePopUp:
                    
                    node.set(perimeterType: perimeterType, edge: .west)
                    
                default: break
                }
                
                viewModel.state = .inspecting(grid, inspectable)
                
            default: break
            }
            
        default: break
        }
    }

    lazy var viewModel = {
        
        return AreaInspectorViewModel(initialState: .empty)
    }()
}

extension AreaInspectorViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange)
    }
}

extension AreaInspectorViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .inspecting(let grid, let inspectable):
            
            chunkCount.integerValue = grid.totalChildren
            gridHiddenButton.state = (grid.isHidden ? .off : .on)
            
            chunkBox.isHidden = true
            tileBox.isHidden = true
            nodeBox.isHidden = true
            
            selectedNodePopUp.removeAllItems()
            selectedSurfaceTypePopUp.removeAllItems()
            selectedExternalPrefabTypePopUp.removeAllItems()
            selectedInternalPrefabTypePopUp.removeAllItems()
            selectedNorthPerimeterTypePopUp.removeAllItems()
            selectedEastPerimeterTypePopUp.removeAllItems()
            selectedSouthPerimeterTypePopUp.removeAllItems()
            selectedWestPerimeterTypePopUp.removeAllItems()
            
            if let (chunk, tile, node) = inspectable {
                
                chunkBox.isHidden = grid.isHidden
                tileBox.isHidden = grid.isHidden || chunk.isHidden
                nodeBox.isHidden = grid.isHidden || chunk.isHidden || tile.isHidden
                
                tileCount.integerValue = chunk.totalChildren
                chunkHiddenButton.state = (chunk.isHidden ? .off : .on)
                tileHiddenButton.state = (tile.isHidden ? .off : .on)
                nodeHiddenButton.state = (node.isHidden ? .off : .on)
                
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
                
                grid.availableSurfaceTypes.forEach { surfaceType in
                    
                    selectedSurfaceTypePopUp.addItem(withTitle: surfaceType.name)
                }
                
                if let surfaceType = node.surfaceType, let index = grid.availableSurfaceTypes.index(of: surfaceType) {
                    
                    selectedSurfaceTypePopUp.selectItem(at: index)
                    
                    surfaceTypecolorPalettePrimary.fillColor = surfaceType.colorPalette.primary.color
                    surfaceTypecolorPaletteSecondary.fillColor = surfaceType.colorPalette.secondary.color
                    surfaceTypecolorPaletteTertiary.fillColor = surfaceType.colorPalette.tertiary.color
                    surfaceTypecolorPaletteQuaternary.fillColor = surfaceType.colorPalette.quaternary.color
                }
                
                let prefabTypes = AreaPrefabType.All
                
                prefabTypes.forEach { areaPrefabType in
                    
                    selectedExternalPrefabTypePopUp.addItem(withTitle: areaPrefabType.description)
                    selectedInternalPrefabTypePopUp.addItem(withTitle: areaPrefabType.description)
                }
                
                if let index = prefabTypes.index(of: node.externalPrefabType) {
                 
                    selectedExternalPrefabTypePopUp.selectItem(at: index)
                }
                
                if let index = prefabTypes.index(of: node.internalPrefabType) {
                    
                    selectedInternalPrefabTypePopUp.selectItem(at: index)
                }
                
                let perimeterTypes = AreaPerimeterType.Identifier.All
                
                perimeterTypes.forEach { perimeterType in
                    
                    selectedNorthPerimeterTypePopUp.addItem(withTitle: perimeterType.description)
                    selectedEastPerimeterTypePopUp.addItem(withTitle: perimeterType.description)
                    selectedSouthPerimeterTypePopUp.addItem(withTitle: perimeterType.description)
                    selectedWestPerimeterTypePopUp.addItem(withTitle: perimeterType.description)
                }
                
                if let perimeterEdge = node.get(perimeterEdge: .north), let index = perimeterTypes.index(of: perimeterEdge.perimeterType.identifier) {
                    
                    selectedNorthPerimeterTypePopUp.selectItem(at: index)
                }
                
                if let perimeterEdge = node.get(perimeterEdge: .east), let index = perimeterTypes.index(of: perimeterEdge.perimeterType.identifier) {
                    
                    selectedEastPerimeterTypePopUp.selectItem(at: index)
                }
                
                if let perimeterEdge = node.get(perimeterEdge: .south), let index = perimeterTypes.index(of: perimeterEdge.perimeterType.identifier) {
                    
                    selectedSouthPerimeterTypePopUp.selectItem(at: index)
                }
                
                if let perimeterEdge = node.get(perimeterEdge: .west), let index = perimeterTypes.index(of: perimeterEdge.perimeterType.identifier) {
                    
                    selectedWestPerimeterTypePopUp.selectItem(at: index)
                }
            }
            
        default: break
        }
    }
}
