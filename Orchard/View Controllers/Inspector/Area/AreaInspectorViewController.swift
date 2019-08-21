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
    @IBOutlet weak var edgeBox: NSBox!
    @IBOutlet weak var fixtureBox: NSBox!
    
    @IBOutlet weak var chunkCount: NSTextField!
    @IBOutlet weak var tileCount: NSTextField!
    @IBOutlet weak var nodeCount: NSTextField!
    @IBOutlet weak var edgeCount: NSTextField!
    
    @IBOutlet weak var gridHiddenButton: NSButton!
    @IBOutlet weak var chunkHiddenButton: NSButton!
    @IBOutlet weak var tileHiddenButton: NSButton!
    @IBOutlet weak var nodeHiddenButton: NSButton!
    @IBOutlet weak var edgeHiddenButton: NSButton!
    @IBOutlet weak var fixtureHiddenButton: NSButton!
    
    @IBOutlet weak var gridEdgeRenderStateButton: NSButton!
    @IBOutlet weak var chunkEdgeRenderStateButton: NSButton!
    
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
    
    @IBOutlet weak var edgeTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var floorTypePopUp: NSPopUpButton!
    @IBOutlet weak var floorColorPalettePopUp: NSPopUpButton!
    @IBOutlet weak var floorColorPaletteView: ColorPaletteView!
    
    @IBOutlet weak var internalMaterialPopUp: NSPopUpButton!
    @IBOutlet weak var internalColorPalettePopUp: NSPopUpButton!
    @IBOutlet weak var internalColorPaletteView: ColorPaletteView!
    
    @IBOutlet weak var externalMaterialPopUp: NSPopUpButton!
    @IBOutlet weak var externalColorPalettePopUp: NSPopUpButton!
    @IBOutlet weak var externalColorPaletteView: ColorPaletteView!
    
    @IBOutlet weak var fixtureTypePopUp: NSPopUpButton!
    @IBOutlet weak var fixtureColorPalettePopUp: NSPopUpButton!
    @IBOutlet weak var fixtureColorPaletteView: ColorPaletteView!
    
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
                
            case edgeHiddenButton:
                
                guard let edge = inspectable.edge else { break }
                
                edge.isHidden = sender.state == .off
                
            case fixtureHiddenButton:
                
                guard let edge = inspectable.edge else { break }
                
                switch edge.edgeType {
                    
                case .door(var door):
                    
                    door.isHidden = sender.state == .off
                    
                case .window(var window):
                    
                    window.isHidden = sender.state == .off
                    
                default: break
                }
                
            case gridEdgeRenderStateButton:
                
                inspectable.grid.renderState = (sender.state == .off ? .cutaway : .raised)
                
            case chunkEdgeRenderStateButton:
                
                guard let chunk = inspectable.chunk else { break }
                
                chunk.renderState = (sender.state == .off ? .cutaway : .raised)
                
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
                
                viewModel.state = .area(editor: editor, inspectable: (grid: inspectable.grid, chunk: inspectable.chunk, tile: tile, node: selectedNode, edge: selectedNode.child(at: 0) as? AreaNodeEdge))
                
                editor.delegate.sceneGraph(didSelectChild: selectedNode, atIndex: sender.indexOfSelectedItem)
                
            case selectedEdgePopUp:
                
                guard let gridEdge = GridEdge(rawValue: sender.indexOfSelectedItem) else { break }
                
                let edge = inspectable.node?.find(edge: gridEdge)
                
                viewModel.state = .area(editor: editor, inspectable: (inspectable.grid, inspectable.chunk, inspectable.tile, inspectable.node, edge))
                
            case floorColorPalettePopUp,
                 floorTypePopUp:
                
                guard let floorType = AreaNodeFloorType(rawValue: floorTypePopUp.indexOfSelectedItem), let colorPalette = ArtDirector.shared?.palettes.children[floorColorPalettePopUp.indexOfSelectedItem], let node = inspectable.node else { break }
                
                node.floor = AreaNodeFloor(colorPalette: colorPalette, floorType: floorType)
                
                viewModel.state = .area(editor: editor, inspectable: inspectable)
                
            case internalMaterialPopUp,
                 internalColorPalettePopUp:
                
                guard let edge = inspectable.edge, let material = AreaNodeEdgeMaterial(rawValue: internalMaterialPopUp.indexOfSelectedItem), let colorPalette = ArtDirector.shared?.palettes.children[internalColorPalettePopUp.indexOfSelectedItem] else { break }
                
                edge.internalEdgeFace = AreaNodeEdgeFace(colorPalette: colorPalette, material: material)
                
                viewModel.state = .area(editor: editor, inspectable: inspectable)
                
            case externalMaterialPopUp,
                 externalColorPalettePopUp:
                
                guard let edge = inspectable.edge, let material = AreaNodeEdgeMaterial(rawValue: externalMaterialPopUp.indexOfSelectedItem), let colorPalette = ArtDirector.shared?.palettes.children[externalColorPalettePopUp.indexOfSelectedItem] else { break }
                
                edge.externalEdgeFace = AreaNodeEdgeFace(colorPalette: colorPalette, material: material)
                
                viewModel.state = .area(editor: editor, inspectable: inspectable)
                
            case edgeTypePopUp:
                
                guard let node = inspectable.node, let edge = inspectable.edge else { break }
                
                node.remove(edge: edge)
                
                if sender.indexOfSelectedItem < AreaNodeEdgeType.allCases.count {
                    
                    let edgeType = AreaNodeEdgeType.allCases[sender.indexOfSelectedItem]
                    
                    switch edgeType {
                        
                    case .door: print("")
                        
                    case .wall: print("")
                        
                    case .window: print("")
                    }
                }
                
                viewModel.state = .area(editor: editor, inspectable: inspectable)
                
            default: break
            }
            
        default: break
        }
    }

    lazy var viewModel = {
        
        return AreaInspectorStateObserver(initialState: .empty)
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
    
        DispatchQueue.main.async {
        
            switch to {
            
            case .area(_, let inspectable):
                
                self.chunkCount.integerValue = inspectable.grid.totalChildren
                self.gridHiddenButton.state = (inspectable.grid.isHidden ? .off : .on)
                
                self.gridEdgeRenderStateButton.state = (inspectable.grid.renderState == .cutaway ? .off : .on)
                self.chunkEdgeRenderStateButton.state = .off
                
                self.chunkBox.isHidden = true
                self.tileBox.isHidden = true
                self.nodeBox.isHidden = true
                self.edgeBox.isHidden = true
                self.fixtureBox.isHidden = true
                
                self.selectedNodePopUp.removeAllItems()
                self.floorTypePopUp.removeAllItems()
                self.floorColorPalettePopUp.removeAllItems()
                self.selectedEdgePopUp.removeAllItems()
                self.edgeTypePopUp.removeAllItems()
                self.internalMaterialPopUp.removeAllItems()
                self.internalColorPalettePopUp.removeAllItems()
                self.externalMaterialPopUp.removeAllItems()
                self.externalColorPalettePopUp.removeAllItems()
                
                if let chunk = inspectable.chunk, let tile = inspectable.tile, let node = inspectable.node {
                    
                    self.chunkEdgeRenderStateButton.state = (chunk.renderState == .cutaway ? .off : .on)
                    
                    self.chunkBox.isHidden = inspectable.grid.isHidden
                    self.tileBox.isHidden = inspectable.grid.isHidden || chunk.isHidden
                    self.nodeBox.isHidden = inspectable.grid.isHidden || chunk.isHidden || tile.isHidden
                    self.edgeBox.isHidden = inspectable.grid.isHidden || chunk.isHidden || tile.isHidden || node.isHidden
                    
                    self.tileCount.integerValue = chunk.totalChildren
                    self.nodeCount.integerValue = tile.totalChildren
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
                        
                        if let nodeEdge = node.child(at: index) as? AreaNodeEdge {
                            
                            self.selectedEdgePopUp.addItem(withTitle: nodeEdge.edge.description)
                        }
                    }
                    
                    if node.totalChildren == 0 {
                        
                        self.edgeTypePopUp.addItem(withTitle: "None")
                    }
                    
                    AreaNodeFloorType.allCases.forEach { floorType in
                        
                        self.floorTypePopUp.addItem(withTitle: floorType.name)
                    }
                    
                    if let floor = node.floor, let index = AreaNodeFloorType.allCases.firstIndex(of: floor.floorType) {
                        
                        self.floorTypePopUp.selectItem(at: index)
                        
                        self.floorColorPaletteView.colorPalette = floor.colorPalette
                    }
                    else {
                        
                        self.floorColorPaletteView.colorPalette = nil
                    }
                    
                    ArtDirector.shared?.palettes.children.forEach { palette in
                        
                        self.floorColorPalettePopUp.addItem(withTitle: palette.name)
                        self.internalColorPalettePopUp.addItem(withTitle: palette.name)
                        self.externalColorPalettePopUp.addItem(withTitle: palette.name)
                    }
                    
                    if let floor = node.floor, let index = ArtDirector.shared?.palettes.children.index(of: floor.colorPalette) {
                        
                        self.floorColorPalettePopUp.selectItem(at: index)
                    }
                    
                    guard let edge = inspectable.edge else {
                        
                        self.edgeBox.isHidden = true
                        
                        break
                    }
                    
                    self.edgeHiddenButton.state = (edge.isHidden ? .off : .on)
                    
                    self.selectedEdgePopUp.selectItem(at: edge.edge.rawValue)
                    
                    AreaNodeEdgeType.allCases.forEach { edgeType in
                        
                        self.edgeTypePopUp.addItem(withTitle: edgeType.stringValue.capitalisingFirstLetter())
                    }
                    
                    self.edgeTypePopUp.addItem(withTitle: "None")
                    
                    var edgeType = AreaNodeEdgeType.CodingKeys.wall
                    
                    switch edge.edgeType {
                        
                    case .door(let door):
                     
                        edgeType = .door
                        
                        self.fixtureBox.isHidden = false
                        
                        AreaNodeEdgeDoorType.allCases.forEach { doorType in
                            
                            self.fixtureTypePopUp.addItem(withTitle: doorType.name)
                        }
                        
                        if let index = AreaNodeEdgeDoorType.allCases.firstIndex(of: door.doorType) {
                            
                            self.fixtureTypePopUp.selectItem(at: index)
                        }
                        
                    case .window(let window):
                        
                        edgeType = .window
                        
                        self.fixtureBox.isHidden = false
                        
                        AreaNodeEdgeWindowType.allCases.forEach { windowType in
                            
                            self.fixtureTypePopUp.addItem(withTitle: windowType.name)
                        }
                        
                        if let index = AreaNodeEdgeWindowType.allCases.firstIndex(of: window.windowType) {
                            
                            self.fixtureTypePopUp.selectItem(at: index)
                        }
                        
                    default:
                        
                        edgeType = .wall
                    }
                    
                    if let index = AreaNodeEdgeType.allCases.firstIndex(of: edgeType) {
                        
                        self.edgeTypePopUp.selectItem(at: index)
                    }
                    
                    AreaNodeEdgeMaterial.allCases.forEach { material in
                        
                        self.internalMaterialPopUp.addItem(withTitle: material.name)
                        self.externalMaterialPopUp.addItem(withTitle: material.name)
                    }
                    
                    if let index = AreaNodeEdgeMaterial.allCases.firstIndex(of: edge.internalEdgeFace.material) {
                        
                        self.internalMaterialPopUp.selectItem(at: index)
                    }
                    
                    if let index = AreaNodeEdgeMaterial.allCases.firstIndex(of: edge.externalEdgeFace.material) {
                        
                        self.externalMaterialPopUp.selectItem(at: index)
                    }
                    
                    if let index = ArtDirector.shared?.palettes.children.index(of: edge.internalEdgeFace.colorPalette) {
                        
                        self.internalColorPalettePopUp.selectItem(at: index)
                        
                        self.internalColorPaletteView.colorPalette = edge.internalEdgeFace.colorPalette
                    }
                    
                    if let index = ArtDirector.shared?.palettes.children.index(of: edge.externalEdgeFace.colorPalette) {
                        
                        self.externalColorPalettePopUp.selectItem(at: index)
                        
                        self.externalColorPaletteView.colorPalette = edge.externalEdgeFace.colorPalette
                    }
                }
                
            default: break
            }
        }
    }
}
