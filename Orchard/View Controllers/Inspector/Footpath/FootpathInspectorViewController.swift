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
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .inspecting(let grid, let inspectable):
            
            guard let (tile, _) = inspectable else { break }
            
            switch sender {
                
            case selectedNodePopUp:
                
                guard let selectedNode = tile.sceneGraph(childAtIndex: sender.indexOfSelectedItem) as? FootpathNode else { break }
                
                viewModel.state = .inspecting(grid, (tile, selectedNode))
                
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
            
            chunkCount.stringValue = "\(grid.totalChildren)"
            
            tileBox.isHidden = true
            nodeBox.isHidden = true
            
            selectedNodePopUp.removeAllItems()
            
            if let (tile, node) = inspectable {
                
                tileBox.isHidden = false
                nodeBox.isHidden = false
                
                xTileCoordinateLabel.stringValue = "\(tile.volume.coordinate.x)"
                yTileCoordinateLabel.stringValue = "\(tile.volume.coordinate.y)"
                zTileCoordinateLabel.stringValue = "\(tile.volume.coordinate.z)"
                
                for index in 0..<tile.totalChildren {
                    
                    selectedNodePopUp.addItem(withTitle: "Node \(index + 1)")
                }
                
                if let index = tile.sceneGraph(indexOf: node) {
                    
                    selectedNodePopUp.selectItem(at: index)
                }
                
                xNodeCoordinateLabel.stringValue = "\(node.volume.coordinate.x)"
                yNodeCoordinateLabel.stringValue = "\(node.volume.coordinate.y)"
                zNodeCoordinateLabel.stringValue = "\(node.volume.coordinate.z)"
                widthNodeSizeLabel.stringValue = "\(node.volume.size.width)"
                heightNodeSizeLabel.stringValue = "\(node.volume.size.height)"
                depthNodeSizeLabel.stringValue = "\(node.volume.size.depth)"
            }
            
        default: break
        }
    }
}
