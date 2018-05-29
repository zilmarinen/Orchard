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
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
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
            
        case .inspecting(let footpath, let inspectable):
            
            chunkCount.stringValue = "\(footpath.totalChildren)"
            
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
            }
            
        default: break
        }
    }
}
