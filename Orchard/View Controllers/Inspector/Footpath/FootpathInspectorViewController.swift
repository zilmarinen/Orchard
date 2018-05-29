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
    
    @IBOutlet weak var tileBox: NSBox!
    @IBOutlet weak var nodeBox: NSBox!
    
    @IBOutlet weak var chunkCount: NSTextField!
    
    @IBOutlet weak var xTileCoordinateLabel: NSTextField!
    @IBOutlet weak var yTileCoordinateLabel: NSTextField!
    @IBOutlet weak var zTileCoordinateLabel: NSTextField!
    
    @IBOutlet weak var selectedNodePopUp: NSPopUpButton!
    
    @IBOutlet weak var sceneView: SCNView!
    
    @IBOutlet weak var xNodeCoordinateLabel: NSTextField!
    @IBOutlet weak var yNodeCoordinateLabel: NSTextField!
    @IBOutlet weak var zNodeCoordinateLabel: NSTextField!
    @IBOutlet weak var widthNodeSizeLabel: NSTextField!
    @IBOutlet weak var heightNodeSizeLabel: NSTextField!
    @IBOutlet weak var depthNodeSizeLabel: NSTextField!
    
    @IBOutlet weak var selectedFootpathTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var slopeEdgeButton: NSButton!
    
    @IBOutlet weak var selectedSlopeEdgePopUp: NSPopUpButton!
    
    
    @IBAction func button(_ sender: NSButton) {
        
        switch viewModel.state {
            
        case .inspecting(let grid, let inspectable):
            
            guard let (_, node) = inspectable else { break }
            
            switch sender .state {
                
            case .on:
                
                node.slope = GridEdge(rawValue: selectedSlopeEdgePopUp.indexOfSelectedItem)
                
            default:
                
                node.slope = nil
            }
            
            viewModel.state = .inspecting(grid, inspectable)
            
        default: break
        }
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .inspecting(let grid, let inspectable):
            
            guard let (tile, node) = inspectable else { break }
            
            switch sender {
                
            case selectedNodePopUp:
                
                guard let selectedNode = tile.sceneGraph(childAtIndex: sender.indexOfSelectedItem) as? FootpathNode else { break }
                
                viewModel.state = .inspecting(grid, (tile, selectedNode))
                
            case selectedFootpathTypePopUp:
                
                let selectedFootpathType = grid.availableFootpathTypes[sender.indexOfSelectedItem]
                
                node.footpathType = selectedFootpathType
                
                viewModel.state = .inspecting(grid, inspectable)
                
            case selectedSlopeEdgePopUp:
                
                guard let selectedEdge = GridEdge(rawValue: sender.indexOfSelectedItem) else { break }
                
                node.slope = selectedEdge
                
                viewModel.state = .inspecting(grid, inspectable)
                
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
        
        viewModel.subscribe(stateDidChange)
    }
}

extension FootpathInspectorViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .inspecting(let grid, let inspectable):
            
            chunkCount.integerValue = grid.totalChildren
            
            tileBox.isHidden = true
            nodeBox.isHidden = true
            
            selectedNodePopUp.removeAllItems()
            selectedFootpathTypePopUp.removeAllItems()
            selectedSlopeEdgePopUp.removeAllItems()
            
            selectedSlopeEdgePopUp.isEnabled = false
            
            if let (tile, node) = inspectable {
                
                tileBox.isHidden = false
                nodeBox.isHidden = false
                
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
                
                grid.availableFootpathTypes.forEach { footpathType in
                    
                    selectedFootpathTypePopUp.addItem(withTitle: footpathType.name)
                }
                
                if let footpathType = node.footpathType, let index = grid.availableFootpathTypes.index(of: footpathType) {
                    
                    selectedFootpathTypePopUp.selectItem(at: index)
                }
                
                slopeEdgeButton.state = (node.slope != nil ? .on : .off)
                
                selectedSlopeEdgePopUp.addItem(withTitle: GridEdge.north.description)
                selectedSlopeEdgePopUp.addItem(withTitle: GridEdge.east.description)
                selectedSlopeEdgePopUp.addItem(withTitle: GridEdge.south.description)
                selectedSlopeEdgePopUp.addItem(withTitle: GridEdge.west.description)
                
                if let slope = node.slope {
                    
                    selectedSlopeEdgePopUp.isEnabled = true
                    
                    selectedSlopeEdgePopUp.selectItem(at: slope.rawValue)
                }
            }
            
        default: break
        }
    }
}
