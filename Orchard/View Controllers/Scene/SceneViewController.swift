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
    
    var meadow: Meadow!

    var delegate: GridDelegate?
}

extension SceneViewController {
    
    override func awakeFromNib() {
        
        self.meadow = Meadow(delegate: self)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        sceneView.scene = meadow
        sceneView.delegate = meadow
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        
        let terrainNode = meadow.terrain.add(node: Coordinate.Zero)
        
        if let terrainNode = terrainNode, let terrainType = meadow.terrain.availableTerrainTypes.first {
            
            let _ = terrainNode.add(layer: terrainType)
            let _ = terrainNode.add(layer: terrainType)
        }
        
        let footpathNode = meadow.footpaths.add(node: Coordinate.Zero)
        
        if let footpathNode = footpathNode, let footpathType = meadow.footpaths.availableFootpathTypes.first {
            
            footpathNode.footpathType = footpathType
        }
        
        meadow.cameraJib.position = SCNVector3(x: 0.0, y: 5.0, z: 10.0)
    }
}

extension SceneViewController: GridDelegate {
    
    func didBecomeDirty(node: GridNode) {
        
        delegate?.didBecomeDirty(node: node)
    }
}
