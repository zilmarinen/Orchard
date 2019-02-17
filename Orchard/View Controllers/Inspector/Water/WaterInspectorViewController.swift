//
//  WaterInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 19/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import SceneKit

class WaterInspectorViewController: NSViewController {
    
    @IBOutlet weak var chunkBox: NSBox!
    @IBOutlet weak var tileBox: NSBox!
    @IBOutlet weak var nodeBox: NSBox!
    @IBOutlet weak var edgeBox: NSBox!
    
    @IBOutlet weak var chunkCount: NSTextField!
    @IBOutlet weak var tileCount: NSTextField!
    @IBOutlet weak var edgeCount: NSTextField!
    
    @IBOutlet weak var gridHiddenButton: NSButton!
    @IBOutlet weak var chunkHiddenButton: NSButton!
    @IBOutlet weak var tileHiddenButton: NSButton!
    @IBOutlet weak var nodeHiddenButton: NSButton!
    @IBOutlet weak var edgeHiddenButton: NSButton!
    
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
    
    @IBOutlet weak var selectedWaterTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var colorPaletteView: ColorPaletteView!
    
    @IBOutlet weak var waterLevelTextField: NSTextField!
    
    @IBOutlet weak var waterLevelStepper: NSStepper!
    
    @IBAction func button(_ sender: NSButton) {
        
        switch viewModel.state {
            
        case .water(let editor, let inspectable):
            
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
                
            default: break
            }
            
            viewModel.state = .water(editor: editor, inspectable: inspectable)
            
        default: break
        }
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .water(let editor, let inspectable):
            
            switch sender {
                
            case selectedNodePopUp:
                
                guard let tile = inspectable.tile, let selectedNode = tile.child(at: sender.indexOfSelectedItem) as? WaterNode else { break }
                
                viewModel.state = .water(editor: editor, inspectable: (grid: inspectable.grid, chunk: inspectable.chunk, tile: tile, node: selectedNode, edge: selectedNode.child(at: 0) as? WaterNodeEdge))
                
                editor.delegate.sceneGraph(didSelectChild: selectedNode, atIndex: sender.indexOfSelectedItem)
                
            case selectedEdgePopUp:
                
                guard let gridEdge = GridEdge(rawValue: sender.indexOfSelectedItem) else { break }
                
                let edge = inspectable.node?.find(edge: gridEdge)
                
                viewModel.state = .water(editor: editor, inspectable: (inspectable.grid, inspectable.chunk, inspectable.tile, inspectable.node, edge))
                
            case selectedWaterTypePopUp:
                
                guard let edge = inspectable.edge, let selectedWaterType = WaterType(rawValue: sender.indexOfSelectedItem) else { break }
                
                edge.waterType = selectedWaterType
                
                viewModel.state = .water(editor: editor, inspectable: inspectable)
                
            default: break
            }
            
        default: break
        }
    }
    
    @IBAction func stepper(_ sender: NSStepper) {
        
        switch viewModel.state {
            
        case .water(let editor, let inspectable):
            
            guard let edge = inspectable.edge else { break }
            
            switch sender {
                
            case waterLevelStepper:
                
                edge.waterLevel = sender.integerValue
                
            default: break
            }
            
            viewModel.state = .water(editor: editor, inspectable: inspectable)
            
        default: break
        }
    }
    
    @IBAction func textField(_ sender: NSTextField) {
        
        switch viewModel.state {
            
        case .water(let editor, let inspectable):
            
            guard let edge = inspectable.edge else { break }
            
            switch sender {
                
            case waterLevelStepper:
                
                edge.waterLevel = sender.integerValue
                
            default: break
            }
            
            viewModel.state = .water(editor: editor, inspectable: inspectable)
            
        default: break
        }
    }

    lazy var viewModel = {
        
        return WaterInspectorViewModel(initialState: .empty)
    }()
}

extension WaterInspectorViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension WaterInspectorViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .water(_, let inspectable):
            
            chunkCount.integerValue = inspectable.grid.totalChildren
            gridHiddenButton.state = (inspectable.grid.isHidden ? .off : .on)
            
            chunkBox.isHidden = true
            tileBox.isHidden = true
            nodeBox.isHidden = true
            edgeBox.isHidden = true
            
            selectedNodePopUp.removeAllItems()
            selectedEdgePopUp.removeAllItems()
            selectedWaterTypePopUp.removeAllItems()
            
            if let chunk = inspectable.chunk, let tile = inspectable.tile, let node = inspectable.node {
                
                chunkBox.isHidden = inspectable.grid.isHidden
                tileBox.isHidden = inspectable.grid.isHidden || chunk.isHidden
                nodeBox.isHidden = inspectable.grid.isHidden || chunk.isHidden || tile.isHidden
                edgeBox.isHidden = inspectable.grid.isHidden || chunk.isHidden || tile.isHidden || node.isHidden
                
                tileCount.integerValue = chunk.totalChildren
                edgeCount.integerValue = node.totalChildren
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
                
                for index in 0..<node.totalChildren {
                    
                    if let nodeEdge = node.child(at: index) as? WaterNodeEdge {
                        
                        selectedEdgePopUp.addItem(withTitle: nodeEdge.edge.description)
                    }
                }
                
                guard let edge = inspectable.edge else { break }
                
                edgeHiddenButton.state = (edge.isHidden ? .off : .on)
                
                if let index = GridEdge.Edges.index(of: edge.edge) {
                    
                    selectedEdgePopUp.selectItem(at: index)
                }
                
                waterLevelStepper.maxValue = Double(World.ceiling)
                waterLevelStepper.minValue = Double(World.floor + 1)
                waterLevelStepper.integerValue = edge.waterLevel
                
                waterLevelTextField.integerValue = waterLevelStepper.integerValue
                
                WaterType.allCases.forEach { waterType in
                    
                    selectedWaterTypePopUp.addItem(withTitle: waterType.name)
                }
                
                if let index = WaterType.allCases.index(of: edge.waterType), let colorPalette = edge.waterType.colorPalette {
                    
                    selectedWaterTypePopUp.selectItem(at: index)
                    
                    colorPaletteView.colorPalette = colorPalette
                }
                else {
                    
                    colorPaletteView.colorPalette = nil
                }
            }
            
        default: break
        }
    }
}
