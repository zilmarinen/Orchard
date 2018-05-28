//
//  TerrainInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 19/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import SceneKit

class TerrainInspectorViewController: NSViewController {
    
    @IBOutlet weak var tileBox: NSBox!
    @IBOutlet weak var layerBox: NSBox!
    
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
        
        return TerrainInspectorViewModel(initialState: .empty)
    }()
}

extension TerrainInspectorViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange)
    }
}

extension TerrainInspectorViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .inspecting(let terrain, let layer):
            
            chunkCount.stringValue = "\(terrain.totalChildren)"
            
            //
            
        default: break
        }
    }
}
