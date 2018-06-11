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
        
        
        for x in 3..<7 {
            
            for z in 3..<7 {
                
                let coordinate = Coordinate(x: x, y: World.Floor + 2, z: z)
        
                if let areaNode = meadow.areas.add(node: coordinate) {
            
                    areaNode.surfaceType = meadow.areas.availableSurfaceTypes.first
                }
            }
        }
    }
}

extension SceneViewController: SoilableDelegate {
    
    func didBecomeDirty(soilable: Soilable) {
        
        delegate?.didBecomeDirty(soilable: soilable)
    }
}
