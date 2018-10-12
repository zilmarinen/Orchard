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
    @IBOutlet weak var floorColorPaletteView: ColorPaletteView!
    
    @IBOutlet weak var selectedEdgePopup: NSPopUpButton!
    @IBOutlet weak var selectedEdgeTypePopup: NSPopUpButton!
    @IBOutlet weak var selectedArchitectureTypePopup: NSPopUpButton!
    
    @IBOutlet weak var externalColorPalettePopup: NSPopUpButton!
    @IBOutlet weak var externalColorPaletteView: ColorPaletteView!
    
    @IBOutlet weak var internalColorPalettePopup: NSPopUpButton!
    @IBOutlet weak var internalColorPaletteView: ColorPaletteView!
    
    @IBAction func button(_ sender: NSButton) {
        
        switch viewModel.state {
            
        case .area(let editor, let inspectable):
            
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
                
            default: break
            }
            
            viewModel.state = .area(editor: editor, inspectable: inspectable)
            
        default: break
        }
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .area(let editor, let inspectable):
            
            switch sender {
                
            case selectedNodePopUp:
                
                guard let tile = inspectable.tile, let selectedNode = tile.child(at: sender.indexOfSelectedItem) as? AreaNode else { break }
                
                viewModel.state = .area(editor: editor, inspectable: (inspectable.grid, inspectable.chunk, tile, selectedNode, inspectable.edge))
                
                editor.delegate.sceneGraph(didSelectChild: selectedNode, atIndex: sender.indexOfSelectedItem)
                
            case selectedFloorColorPalettePopUp:
                
                guard let node = inspectable.node else { break }
                
                let selectedColorPalette = ColorPalettes.shared?.allColorPalettes[sender.indexOfSelectedItem]

                node.floorColorPalette = selectedColorPalette

                viewModel.state = .area(editor: editor, inspectable: inspectable)
                
            case selectedExternalAreaTypePopUp,
                 selectedInternalAreaTypePopUp:
                
                guard let node = inspectable.node, let selectedAreaType = AreaType(rawValue: sender.indexOfSelectedItem) else { break }
                
                if sender == selectedExternalAreaTypePopUp {
                 
                    node.externalAreaType = selectedAreaType
                }
                else {
                    
                    node.internalAreaType = selectedAreaType
                }
                
                viewModel.state = .area(editor: editor, inspectable: inspectable)
                
            case selectedEdgePopup:
                
                guard let selectedEdge = GridEdge(rawValue: sender.indexOfSelectedItem) else { break }
                
                viewModel.state = .area(editor: editor, inspectable: (inspectable.grid, inspectable.chunk, inspectable.tile, inspectable.node, selectedEdge))
                
            case selectedEdgeTypePopup:
                
                guard let node = inspectable.node else { break }
                
                if let edgeType = AreaNodeEdgeType(rawValue: sender.indexOfSelectedItem) {
                    
                    guard let colorPalettes = ColorPalettes.shared else { break }
                    
                    let nodeEdge = node.anyEdge()
                    
                    let architectureType = (nodeEdge?.architectureType ?? AreaArchitectureType.allCases[selectedArchitectureTypePopup.indexOfSelectedItem])
                    let externalColorPalette = (nodeEdge?.externalColorPalette ?? colorPalettes.allColorPalettes[externalColorPalettePopup.indexOfSelectedItem])
                    let internalColorPalette = (nodeEdge?.internalColorPalette ?? colorPalettes.allColorPalettes[internalColorPalettePopup.indexOfSelectedItem])
                    
                    node.set(edge: AreaNode.Edge(edge: inspectable.edge, edgeType: edgeType, architectureType: architectureType, externalColorPalette: externalColorPalette, internalColorPalette: internalColorPalette))
                }
                else {
                    
                    node.remove(edge: inspectable.edge)
                }
                
                viewModel.state = .area(editor: editor, inspectable: inspectable)
                
            case selectedArchitectureTypePopup:
                
                guard let node = inspectable.node else { break }
                
                if let nodeEdge = node.find(edge: inspectable.edge) {
                    
                    let architectureType = AreaArchitectureType.allCases[selectedArchitectureTypePopup.indexOfSelectedItem]
                    
                    node.set(edge: AreaNode.Edge(edge: nodeEdge.edge, edgeType: nodeEdge.edgeType, architectureType: architectureType, externalColorPalette: nodeEdge.externalColorPalette, internalColorPalette: nodeEdge.internalColorPalette))
                    
                    viewModel.state = .area(editor: editor, inspectable: inspectable)
                }
                
                viewModel.state = .area(editor: editor, inspectable: inspectable)
                
            case externalColorPalettePopup:
                
                guard let node = inspectable.node else { break }
                
                if let nodeEdge = node.find(edge: inspectable.edge) {
                 
                    guard let colorPalette = ColorPalettes.shared?.allColorPalettes[sender.indexOfSelectedItem] else { break }
                    
                    node.set(edge: AreaNode.Edge(edge: nodeEdge.edge, edgeType: nodeEdge.edgeType, architectureType: nodeEdge.architectureType, externalColorPalette: colorPalette, internalColorPalette: nodeEdge.internalColorPalette))
                    
                    viewModel.state = .area(editor: editor, inspectable: inspectable)
                }
                
            case internalColorPalettePopup:
                
                guard let node = inspectable.node else { break }
                
                if let nodeEdge = node.find(edge: inspectable.edge) {
                    
                    guard let colorPalette = ColorPalettes.shared?.allColorPalettes[sender.indexOfSelectedItem] else { break }
                    
                    node.set(edge: AreaNode.Edge(edge: nodeEdge.edge, edgeType: nodeEdge.edgeType, architectureType: nodeEdge.architectureType, externalColorPalette: nodeEdge.externalColorPalette, internalColorPalette: colorPalette))
                    
                    viewModel.state = .area(editor: editor, inspectable: inspectable)
                }
                
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
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension AreaInspectorViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .area(_, let inspectable):
            
            chunkCount.integerValue = inspectable.grid.totalChildren
            gridHiddenButton.state = (inspectable.grid.isHidden ? .off : .on)
            
            chunkBox.isHidden = true
            tileBox.isHidden = true
            nodeBox.isHidden = true
            
            selectedNodePopUp.removeAllItems()
            selectedExternalAreaTypePopUp.removeAllItems()
            selectedInternalAreaTypePopUp.removeAllItems()
            selectedFloorColorPalettePopUp.removeAllItems()
            selectedEdgePopup.removeAllItems()
            selectedEdgeTypePopup.removeAllItems()
            selectedArchitectureTypePopup.removeAllItems()
            externalColorPalettePopup.removeAllItems()
            internalColorPalettePopup.removeAllItems()
            
            externalColorPalettePopup.isEnabled = false
            internalColorPalettePopup.isEnabled = false
            
            if let chunk = inspectable.chunk, let tile = inspectable.tile, let node = inspectable.node {
                
                chunkBox.isHidden = inspectable.grid.isHidden
                tileBox.isHidden = inspectable.grid.isHidden || chunk.isHidden
                nodeBox.isHidden = inspectable.grid.isHidden || chunk.isHidden || tile.isHidden
                
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
                
                AreaType.allCases.forEach { areaType in
                    
                    selectedExternalAreaTypePopUp.addItem(withTitle: areaType.name)
                    selectedInternalAreaTypePopUp.addItem(withTitle: areaType.name)
                }
                
                ColorPalettes.shared?.allColorPalettes.forEach { colorPalette in
                    
                    selectedFloorColorPalettePopUp.addItem(withTitle: colorPalette.name)
                    externalColorPalettePopup.addItem(withTitle: colorPalette.name)
                    internalColorPalettePopup.addItem(withTitle: colorPalette.name)
                }
                
                if let areaType = node.externalAreaType {
                    
                    selectedExternalAreaTypePopUp.selectItem(at: areaType.rawValue)
                }
                
                if let areaType = node.internalAreaType {
                    
                    selectedInternalAreaTypePopUp.selectItem(at: areaType.rawValue)
                }
                
                if let colorPalette = node.floorColorPalette, let index = ColorPalettes.shared?.allColorPalettes.index(of: colorPalette) {
                    
                    selectedFloorColorPalettePopUp.selectItem(at: index)
                    
                    floorColorPaletteView.colorPalette = colorPalette
                }
                else {
                    
                    floorColorPaletteView.colorPalette = nil
                }
                
                GridEdge.Edges.forEach { edge in
                    
                    selectedEdgePopup.addItem(withTitle: edge.description)
                }
                
                AreaNodeEdgeType.allCases.forEach { edgeType in
                    
                    selectedEdgeTypePopup.addItem(withTitle: edgeType.name)
                }
                
                AreaArchitectureType.allCases.forEach { architectureType in
                    
                    selectedArchitectureTypePopup.addItem(withTitle: architectureType.name)
                }
                
                selectedEdgeTypePopup.addItem(withTitle: "None")
                
                if let index = GridEdge.Edges.index(of: inspectable.edge) {
                    
                    selectedEdgePopup.selectItem(at: index)
                }
                
                if let nodeEdge = node.find(edge: inspectable.edge) {
                    
                    if let index = AreaNodeEdgeType.allCases.index(of: nodeEdge.edgeType) {
                        
                        selectedEdgeTypePopup.selectItem(at: index)
                    }
                    
                    if let index = AreaArchitectureType.allCases.index(of: nodeEdge.architectureType) {
                        
                        selectedArchitectureTypePopup.selectItem(at: index)
                    }
                    
                    selectedArchitectureTypePopup.isEnabled = (nodeEdge.edgeType != .wall)
                    
                    externalColorPalettePopup.isEnabled = true
                    internalColorPalettePopup.isEnabled = true
                    
                    if let index = ColorPalettes.shared?.allColorPalettes.index(of: nodeEdge.externalColorPalette) {
                        
                        externalColorPalettePopup.selectItem(at: index)
                        
                        externalColorPaletteView.colorPalette = nodeEdge.externalColorPalette
                    }
                    else {
                        
                        externalColorPaletteView.colorPalette = nil
                    }
                    
                    if let index = ColorPalettes.shared?.allColorPalettes.index(of: nodeEdge.internalColorPalette) {
                        
                        internalColorPalettePopup.selectItem(at: index)
                        
                        internalColorPaletteView.colorPalette = nodeEdge.internalColorPalette
                    }
                    else {
                        
                        internalColorPaletteView.colorPalette = nil
                    }
                }
                else {
                    
                    selectedEdgeTypePopup.selectItem(at: AreaNodeEdgeType.allCases.count)
                    
                    externalColorPaletteView.colorPalette = nil
                    internalColorPaletteView.colorPalette = nil
                }
            }
            
        default: break
        }
    }
}
