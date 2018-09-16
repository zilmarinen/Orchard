//
//  SceneViewController.swift
//  Orchard
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import SceneKit

class SceneViewController: NSViewController {

    @IBOutlet weak var sceneView: SCNView!
    
    @IBOutlet weak var xCoordinateLabel: NSTextField!
    @IBOutlet weak var yCoordinateLabel: NSTextField!
    @IBOutlet weak var zCoordinateLabel: NSTextField!
    
    lazy var viewModel = {
        
        return SceneViewModel(initialState: .empty)
    }()
}

extension SceneViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange)
    }
}

extension SceneViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .editor(let meadow):
            
            sceneView.scene = meadow
            sceneView.delegate = meadow
            sceneView.showsStatistics = true
            sceneView.isPlaying = true
            
        case .inspecting(let meadow, let item):
            
            if let item = item as? GridChild {
                
                xCoordinateLabel.integerValue = item.volume.coordinate.x
                yCoordinateLabel.integerValue = item.volume.coordinate.y
                zCoordinateLabel.integerValue = item.volume.coordinate.z
                
                let vector = SCNVector3(x: MDWFloat(item.volume.coordinate.x), y: Axis.Y(y: item.volume.coordinate.y), z: MDWFloat(item.volume.coordinate.z))
                
                switch meadow.cameraJib.stateMachine.state {
                    
                case .focus(_, let edge, let zoomLevel):
                    
                    meadow.cameraJib.stateMachine.state = .focus(vector, edge, zoomLevel)
                }
            }
            
        default: break
        }
    }
}
