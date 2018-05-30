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
        
        if let terrainType = meadow.terrain.availableTerrainTypes.first {
            
            for x in 0..<7 {
                
                for z in 0..<7 {
                    
                    let coordinate = Coordinate(x: x, y: World.Floor, z: z)
                    
                    if let terrainNode = meadow.terrain.add(node: coordinate) {
                        
                        let _ = terrainNode.add(layer: terrainType)
                    }
                }
            }
        }
        
        meadow.cameraJib.position = SCNVector3(x: 2.0, y: 2.0, z: 15.0)
    }
}

extension SceneViewController: GridDelegate {
    
    func didBecomeDirty(node: GridNode) {
        
        delegate?.didBecomeDirty(node: node)
    }
}
