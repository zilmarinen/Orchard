//
//  FootpathInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 19/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import SceneKit

class FootpathInspectorViewController: NSViewController {
    
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
    
    @IBOutlet weak var selectedFootpathTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var colorPaletteView: ColorPaletteView!
    
    @IBOutlet weak var slopeEdgeButton: NSButton!
    
    @IBOutlet weak var steepInclinationButton: NSButton!
    
    @IBOutlet weak var selectedSlopeEdgePopUp: NSPopUpButton!
    
    @IBAction func button(_ sender: NSButton) {
        
        switch viewModel.state {
            
        case .footpath(let editor, let inspectable):
            
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
                
            case slopeEdgeButton,
                 steepInclinationButton:
                
                guard let node = inspectable.node, let selectedEdge = GridEdge(rawValue: selectedSlopeEdgePopUp.indexOfSelectedItem) else { break }
                
                switch slopeEdgeButton.state {
                    
                case .on:
                    
                    let inclination = (steepInclinationButton.state == .on)
                    
                    node.slope = FootpathNode.Slope(edge: selectedEdge, steep: inclination)
                    
                default:
                    
                    node.slope = nil
                }
                
            default: break
            }
            
            viewModel.state = .footpath(editor: editor, inspectable: inspectable)
            
        default: break
        }
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .footpath(let editor, let inspectable):
            
            switch sender {
                
            case selectedNodePopUp:
                
                guard let tile = inspectable.tile, let selectedNode = tile.child(at: sender.indexOfSelectedItem) else { break }
                
                viewModel.state = .footpath(editor: editor, inspectable: (inspectable.grid, inspectable.chunk, tile, selectedNode))
                
                editor.delegate.sceneGraph(didSelectChild: selectedNode, atIndex: sender.indexOfSelectedItem)
                
            case selectedFootpathTypePopUp:
                
                guard let node = inspectable.node, let selectedFootpathType = FootpathType(rawValue: sender.indexOfSelectedItem) else { break }
                
                node.footpathType = selectedFootpathType
                
                viewModel.state = .footpath(editor: editor, inspectable: inspectable)
                
            case selectedSlopeEdgePopUp:
                
                guard let node = inspectable.node, let selectedEdge = GridEdge(rawValue: sender.indexOfSelectedItem) else { break }
                
                switch slopeEdgeButton.state {
                    
                case .on:
                    
                    let inclination = (steepInclinationButton.state == .on)
                    
                    node.slope = FootpathNode.Slope(edge: selectedEdge, steep: inclination)
                    
                default:
                    
                    node.slope = nil
                }
                
                viewModel.state = .footpath(editor: editor, inspectable: inspectable)
                
            default: break
            }
            
        default: break
        }
    }

    lazy var viewModel = {
        
        return FootpathInspectorViewModel(initialState: .empty)
    }()
}

extension FootpathInspectorViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension FootpathInspectorViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .footpath(_, let inspectable):
            
            chunkCount.integerValue = inspectable.grid.totalChildren
            gridHiddenButton.state = (inspectable.grid.isHidden ? .off : .on)
            
            chunkBox.isHidden = true
            tileBox.isHidden = true
            nodeBox.isHidden = true
            
            selectedNodePopUp.removeAllItems()
            selectedFootpathTypePopUp.removeAllItems()
            selectedSlopeEdgePopUp.removeAllItems()
            
            steepInclinationButton.isEnabled = false
            selectedSlopeEdgePopUp.isEnabled = false
            
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
                
                FootpathType.allCases.forEach { footpathType in
                    
                    selectedFootpathTypePopUp.addItem(withTitle: footpathType.name)
                }
                
                if let footpathType = node.footpathType, let index = FootpathType.allCases.index(of: footpathType), let colorPalette = footpathType.colorPalette {
                    
                    selectedFootpathTypePopUp.selectItem(at: index)
                    
                    colorPaletteView.colorPalette = colorPalette
                }
                else {
                    
                    colorPaletteView.colorPalette = nil
                }
                
                steepInclinationButton.state = (node.slope != nil && node.slope!.steep ? .on : .off)
                slopeEdgeButton.state = (node.slope != nil ? .on : .off)
                
                selectedSlopeEdgePopUp.addItem(withTitle: GridEdge.north.description)
                selectedSlopeEdgePopUp.addItem(withTitle: GridEdge.east.description)
                selectedSlopeEdgePopUp.addItem(withTitle: GridEdge.south.description)
                selectedSlopeEdgePopUp.addItem(withTitle: GridEdge.west.description)
                
                if let slope = node.slope {
                    
                    steepInclinationButton.isEnabled = true
                    selectedSlopeEdgePopUp.isEnabled = true
                    
                    selectedSlopeEdgePopUp.selectItem(at: slope.edge.rawValue)
                }
            }
            
        default: break
        }
    }
}
