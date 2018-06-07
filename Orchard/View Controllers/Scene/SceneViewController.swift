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

    var delegate: SoilableDelegate?
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
        
        for x in 0..<10 {
        
            for z in 0..<10 {
            
                let coordinate = Coordinate(x: x, y: World.Floor, z: z)
                
                if let terrainNode = meadow.terrain.add(node: coordinate) {
                
                    if let terrainType = meadow.terrain.availableTerrainTypes.first {
                        
                        let _ = terrainNode.add(layer: terrainType)
                    }
                    
                    if let terrainType = meadow.terrain.availableTerrainTypes.last {
                        
                        let _ = terrainNode.add(layer: terrainType)
                    }
                }
            }
        }
        
        meadow.cameraJib.position = SCNVector3(x: -2.0, y: 5.0, z: 10.0)
        meadow.cameraJib.eulerAngles = SCNVector3(x: -0.7, y: -0.9, z: 0.0)
    }
}

extension SceneViewController: SoilableDelegate {
    
    func didBecomeDirty(soilable: Soilable) {
        
        delegate?.didBecomeDirty(soilable: soilable)
    }
}
