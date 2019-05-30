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
        
        DispatchQueue.main.async {
            
            switch to {
                
            case .water(_, let inspectable):
                
                self.chunkCount.integerValue = inspectable.grid.totalChildren
                self.gridHiddenButton.state = (inspectable.grid.isHidden ? .off : .on)
                
                self.chunkBox.isHidden = true
                self.tileBox.isHidden = true
                self.nodeBox.isHidden = true
                self.edgeBox.isHidden = true
                
                self.selectedNodePopUp.removeAllItems()
                self.selectedEdgePopUp.removeAllItems()
                self.selectedWaterTypePopUp.removeAllItems()
                
                if let chunk = inspectable.chunk, let tile = inspectable.tile, let node = inspectable.node {
                    
                    self.chunkBox.isHidden = inspectable.grid.isHidden
                    self.tileBox.isHidden = inspectable.grid.isHidden || chunk.isHidden
                    self.nodeBox.isHidden = inspectable.grid.isHidden || chunk.isHidden || tile.isHidden
                    self.edgeBox.isHidden = inspectable.grid.isHidden || chunk.isHidden || tile.isHidden || node.isHidden
                    
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
                        
                        if let nodeEdge = node.child(at: index) as? WaterNodeEdge {
                            
                            self.selectedEdgePopUp.addItem(withTitle: nodeEdge.edge.description)
                        }
                    }
                    
                    guard let edge = inspectable.edge else { break }
                    
                    self.edgeHiddenButton.state = (edge.isHidden ? .off : .on)
                    
                    self.selectedEdgePopUp.selectItem(at: edge.edge.rawValue)
                    
                    self.waterLevelStepper.maxValue = Double(World.ceiling)
                    self.waterLevelStepper.minValue = Double(World.floor + 1)
                    self.waterLevelStepper.integerValue = edge.waterLevel
                    
                    self.waterLevelTextField.integerValue = self.waterLevelStepper.integerValue
                    
                    WaterType.allCases.forEach { waterType in
                        
                        self.selectedWaterTypePopUp.addItem(withTitle: waterType.name)
                    }
                    
                    if let index = WaterType.allCases.firstIndex(of: edge.waterType), let colorPalette = edge.waterType.colorPalette {
                        
                        self.selectedWaterTypePopUp.selectItem(at: index)
                        
                        self.colorPaletteView.colorPalette = colorPalette
                    }
                    else {
                        
                        self.colorPaletteView.colorPalette = nil
                    }
                }
                
            default: break
            }
        }
    }
}
