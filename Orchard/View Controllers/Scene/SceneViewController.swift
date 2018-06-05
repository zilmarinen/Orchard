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
        
        /*for x in 0..<7 {
            
            for z in 0..<7 {
                
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
        
        if let footpathType = meadow.footpaths.availableFootpathTypes.last {
            
            for x in 1..<6 {
                
                let coordinate = Coordinate(x: x, y: (World.Floor + 2), z: 2)
                
                if let footpathNode = meadow.footpaths.add(node: coordinate) {
                    
                    footpathNode.footpathType = footpathType
                }
            }
            
            for x in 3..<5 {
                
                let coordinate = Coordinate(x: x, y: (World.Floor + 2), z: 3)
                
                if let footpathNode = meadow.footpaths.add(node: coordinate) {
                    
                    footpathNode.footpathType = footpathType
                }
            }
            
            for z in 1..<6 {
                
                let coordinate = Coordinate(x: 2, y: (World.Floor + 2), z: z)
                
                if let footpathNode = meadow.footpaths.add(node: coordinate) {
                    
                    footpathNode.footpathType = footpathType
                }
            }
        }*/
        
        let coordinate = Coordinate(x: 2, y: (World.Floor + 3), z: 2)
        
        let _ = meadow.water.add(node: coordinate)
        
        meadow.cameraJib.position = SCNVector3(x: 0.0, y: 5.0, z: 5.0)
        meadow.cameraJib.eulerAngles = SCNVector3(x: -1.0, y: -1.0, z: 0.0)
    }
}

extension SceneViewController: SoilableDelegate {
    
    func didBecomeDirty(soilable: Soilable) {
        
        delegate?.didBecomeDirty(soilable: soilable)
    }
}
