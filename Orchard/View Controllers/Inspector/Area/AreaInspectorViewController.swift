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
    
    @IBOutlet weak var surfaceTypeColorPalettePrimary: NSBox!
    @IBOutlet weak var surfaceTypeColorPaletteSecondary: NSBox!
    @IBOutlet weak var surfaceTypeColorPaletteTertiary: NSBox!
    @IBOutlet weak var surfaceTypeColorPaletteQuaternary: NSBox!
    
    @IBOutlet weak var selectedExternalPrefabTypePopUp: NSPopUpButton!
    @IBOutlet weak var selectedExternalMaterialTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var externalMaterialTypeColorPalettePrimary: NSBox!
    @IBOutlet weak var externalMaterialTypeColorPaletteSecondary: NSBox!
    @IBOutlet weak var externalMaterialTypeColorPaletteTertiary: NSBox!
    @IBOutlet weak var externalMaterialTypeColorPaletteQuaternary: NSBox!
    
    @IBOutlet weak var selectedInternalPrefabTypePopUp: NSPopUpButton!
    @IBOutlet weak var selectedInternalMaterialTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var internalMaterialTypeColorPalettePrimary: NSBox!
    @IBOutlet weak var internalMaterialTypeColorPaletteSecondary: NSBox!
    @IBOutlet weak var internalMaterialTypeColorPaletteTertiary: NSBox!
    @IBOutlet weak var internalMaterialTypeColorPaletteQuaternary: NSBox!
    
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
                
                let selectedPrefabType = AreaPrefabType.all[sender.indexOfSelectedItem]
                
                if sender == selectedExternalPrefabTypePopUp {
                 
                    node.externalPrefabType = selectedPrefabType
                }
                else {
                    
                    node.internalPrefabType = selectedPrefabType
                }
                
                viewModel.state = .inspecting(grid, inspectable)
                
            case selectedExternalMaterialTypePopUp,
                 selectedInternalMaterialTypePopUp:
                
                let selectedMaterialType = grid.availableMaterialTypes[sender.indexOfSelectedItem]
                
                if sender == selectedExternalMaterialTypePopUp {
                    
                    node.externalMaterialType = selectedMaterialType
                }
                else {
                    
                    node.internalMaterialType = selectedMaterialType
                }
                
                viewModel.state = .inspecting(grid, inspectable)
                
            case selectedNorthPerimeterTypePopUp,
                 selectedEastPerimeterTypePopUp,
                 selectedSouthPerimeterTypePopUp,
                 selectedWestPerimeterTypePopUp:
                
                var edge = GridEdge.north
                
                switch sender {
                    
                case selectedEastPerimeterTypePopUp: edge = .east
                    
                case selectedSouthPerimeterTypePopUp: edge = .south
                    
                case selectedWestPerimeterTypePopUp: edge = .west
                    
                default: edge = .north
                }
                
                if sender.indexOfSelectedItem == AreaPerimeterType.all.count {
                    
                    node.remove(perimeterType: edge)
                }
                else {
                 
                    let selectedPerimeterType = AreaPerimeterType.all[sender.indexOfSelectedItem]
                    
                    node.set(perimeterType: selectedPerimeterType, edge: edge)
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
            selectedExternalMaterialTypePopUp.removeAllItems()
            selectedInternalPrefabTypePopUp.removeAllItems()
            selectedInternalMaterialTypePopUp.removeAllItems()
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
                    
                    surfaceTypeColorPalettePrimary.fillColor = surfaceType.colorPalette.primary.color
                    surfaceTypeColorPaletteSecondary.fillColor = surfaceType.colorPalette.secondary.color
                    surfaceTypeColorPaletteTertiary.fillColor = surfaceType.colorPalette.tertiary.color
                    surfaceTypeColorPaletteQuaternary.fillColor = surfaceType.colorPalette.quaternary.color
                }
                
                grid.availableMaterialTypes.forEach { materialType in
                    
                    selectedExternalMaterialTypePopUp.addItem(withTitle: materialType.name)
                    selectedInternalMaterialTypePopUp.addItem(withTitle: materialType.name)
                }
                
                if let materialType = node.externalMaterialType, let index = grid.availableMaterialTypes.index(of: materialType) {
                    
                    selectedExternalMaterialTypePopUp.selectItem(at: index)
                    
                    externalMaterialTypeColorPalettePrimary.fillColor = materialType.colorPalette.primary.color
                    externalMaterialTypeColorPaletteSecondary.fillColor = materialType.colorPalette.secondary.color
                    externalMaterialTypeColorPaletteTertiary.fillColor = materialType.colorPalette.tertiary.color
                    externalMaterialTypeColorPaletteQuaternary.fillColor = materialType.colorPalette.quaternary.color
                }
                
                if let materialType = node.internalMaterialType, let index = grid.availableMaterialTypes.index(of: materialType) {
                    
                    selectedInternalMaterialTypePopUp.selectItem(at: index)
                    
                    internalMaterialTypeColorPalettePrimary.fillColor = materialType.colorPalette.primary.color
                    internalMaterialTypeColorPaletteSecondary.fillColor = materialType.colorPalette.secondary.color
                    internalMaterialTypeColorPaletteTertiary.fillColor = materialType.colorPalette.tertiary.color
                    internalMaterialTypeColorPaletteQuaternary.fillColor = materialType.colorPalette.quaternary.color
                }
                
                let prefabTypes = AreaPrefabType.all
                
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
                
                let perimeterTypes = AreaPerimeterType.all
                
                perimeterTypes.forEach { perimeterType in
                    
                    selectedNorthPerimeterTypePopUp.addItem(withTitle: perimeterType.description)
                    selectedEastPerimeterTypePopUp.addItem(withTitle: perimeterType.description)
                    selectedSouthPerimeterTypePopUp.addItem(withTitle: perimeterType.description)
                    selectedWestPerimeterTypePopUp.addItem(withTitle: perimeterType.description)
                }
                
                selectedNorthPerimeterTypePopUp.addItem(withTitle: "None")
                selectedEastPerimeterTypePopUp.addItem(withTitle: "None")
                selectedSouthPerimeterTypePopUp.addItem(withTitle: "None")
                selectedWestPerimeterTypePopUp.addItem(withTitle: "None")
                
                selectedNorthPerimeterTypePopUp.selectItem(at: perimeterTypes.count)
                selectedEastPerimeterTypePopUp.selectItem(at: perimeterTypes.count)
                selectedSouthPerimeterTypePopUp.selectItem(at: perimeterTypes.count)
                selectedWestPerimeterTypePopUp.selectItem(at: perimeterTypes.count)
                
                if let perimeterEdge = node.get(perimeterEdge: .north), let index = perimeterTypes.index(of: perimeterEdge.perimeterType) {
                    
                    selectedNorthPerimeterTypePopUp.selectItem(at: index)
                }
                
                if let perimeterEdge = node.get(perimeterEdge: .east), let index = perimeterTypes.index(of: perimeterEdge.perimeterType) {
                    
                    selectedEastPerimeterTypePopUp.selectItem(at: index)
                }
                
                if let perimeterEdge = node.get(perimeterEdge: .south), let index = perimeterTypes.index(of: perimeterEdge.perimeterType) {
                    
                    selectedSouthPerimeterTypePopUp.selectItem(at: index)
                }
                
                if let perimeterEdge = node.get(perimeterEdge: .west), let index = perimeterTypes.index(of: perimeterEdge.perimeterType) {
                    
                    selectedWestPerimeterTypePopUp.selectItem(at: index)
                }
            }
            
        default: break
        }
    }
}
