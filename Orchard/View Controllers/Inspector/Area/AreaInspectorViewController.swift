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
    
    @IBOutlet weak var selectedExternalAreaTypePopUp: NSPopUpButton!
    @IBOutlet weak var selectedInternalAreaTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var selectedFloorColorPalettePopUp: NSPopUpButton!
    
    @IBOutlet weak var floorColorPalettePrimary: NSBox!
    @IBOutlet weak var floorColorPaletteSecondary: NSBox!
    @IBOutlet weak var floorColorPaletteTertiary: NSBox!
    @IBOutlet weak var floorColorPaletteQuaternary: NSBox!
    
    @IBOutlet weak var selectedNorthEdgeTypePopup: NSPopUpButton!
    @IBOutlet weak var selectedNorthEdgeColorPalettePopup: NSPopUpButton!
    @IBOutlet weak var northEdgeColorPalettePrimary: NSBox!
    @IBOutlet weak var northEdgeColorPaletteSecondary: NSBox!
    @IBOutlet weak var northEdgeColorPaletteTertiary: NSBox!
    @IBOutlet weak var northEdgeColorPaletteQuaternary: NSBox!
    
    @IBOutlet weak var selectedEastEdgeTypePopup: NSPopUpButton!
    @IBOutlet weak var selectedEastEdgeColorPalettePopup: NSPopUpButton!
    @IBOutlet weak var eastEdgeColorPalettePrimary: NSBox!
    @IBOutlet weak var eastEdgeColorPaletteSecondary: NSBox!
    @IBOutlet weak var eastEdgeColorPaletteTertiary: NSBox!
    @IBOutlet weak var eastEdgeColorPaletteQuaternary: NSBox!
    
    @IBOutlet weak var selectedSouthEdgeTypePopup: NSPopUpButton!
    @IBOutlet weak var selectedSouthEdgeColorPalettePopup: NSPopUpButton!
    @IBOutlet weak var southEdgeColorPalettePrimary: NSBox!
    @IBOutlet weak var southEdgeColorPaletteSecondary: NSBox!
    @IBOutlet weak var southEdgeColorPaletteTertiary: NSBox!
    @IBOutlet weak var southEdgeColorPaletteQuaternary: NSBox!
    
    @IBOutlet weak var selectedWestEdgeTypePopup: NSPopUpButton!
    @IBOutlet weak var selectedWestEdgeColorPalettePopup: NSPopUpButton!
    @IBOutlet weak var westEdgeColorPalettePrimary: NSBox!
    @IBOutlet weak var westEdgeColorPaletteSecondary: NSBox!
    @IBOutlet weak var westEdgeColorPaletteTertiary: NSBox!
    @IBOutlet weak var westEdgeColorPaletteQuaternary: NSBox!
    
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
                
                guard let selectedNode = tile.child(at: sender.indexOfSelectedItem) as? AreaNode else { break }
                
                viewModel.state = .inspecting(grid, (chunk, tile, selectedNode))
                
            case selectedFloorColorPalettePopUp:
                
//                let selectedColorPalette = grid.availableSurfaceTypes[sender.indexOfSelectedItem]
//
//                node.floorColorPalette = selectedSurfaceType
//
                viewModel.state = .inspecting(grid, inspectable)
                
            case selectedExternalAreaTypePopUp,
                 selectedInternalAreaTypePopUp:
                
                guard let selectedAreaType = AreaType(rawValue: sender.indexOfSelectedItem) else { break }
                
                if sender == selectedExternalAreaTypePopUp {
                 
                    node.externalAreaType = selectedAreaType
                }
                else {
                    
                    node.internalAreaType = selectedAreaType
                }
                
                viewModel.state = .inspecting(grid, inspectable)
                
            case selectedNorthEdgeTypePopup,
                 selectedEastEdgeTypePopup,
                 selectedSouthEdgeTypePopup,
                 selectedWestEdgeTypePopup:
                
                var edge = GridEdge.north
                
                switch sender {
                    
                case selectedEastEdgeTypePopup: edge = .east
                    
                case selectedSouthEdgeTypePopup: edge = .south
                    
                case selectedWestEdgeTypePopup: edge = .west
                    
                default: edge = .north
                }
//
//                if sender.indexOfSelectedItem == AreaPerimeterType.all.count {
//
//                    node.remove(perimeterType: edge)
//                }
//                else {
//
//                    let selectedPerimeterType = AreaPerimeterType.all[sender.indexOfSelectedItem]
//
//                    node.set(perimeterType: selectedPerimeterType, edge: edge)
//                }
                
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
                
                if let index = tile.index(of: node) {
                 
                    selectedNodePopUp.selectItem(at: index)
                }
                
                xNodeCoordinateLabel.integerValue = node.volume.coordinate.x
                yNodeCoordinateLabel.integerValue = node.volume.coordinate.y
                zNodeCoordinateLabel.integerValue = node.volume.coordinate.z
                widthNodeSizeLabel.integerValue = node.volume.size.width
                heightNodeSizeLabel.integerValue = node.volume.size.height
                depthNodeSizeLabel.integerValue = node.volume.size.depth
            }
            
        default: break
        }
    }
}
