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

    var observer: GridObserver?
}

extension SceneViewController {
    
    override func awakeFromNib() {
        
        self.meadow = Meadow(observer: self)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        sceneView.scene = meadow
        sceneView.delegate = meadow
        sceneView.showsStatistics = true
        
        for x in 0..<10 {
        
            for z in 0..<10 {
            
                let coordinate = Coordinate(x: x, y: World.floor, z: z)
                
                if let terrainNode = meadow.terrain.add(node: coordinate) {
                
                    let _ = terrainNode.add(layer: TerrainType.bedrock)
                    
                    let _ = terrainNode.add(layer: TerrainType.grass)
                }
            }
        }
        
        for x in 0..<10 {
            
            let coordinate = Coordinate(x: x, y: World.floor, z: 1)
                
            if let terrainNode = meadow.terrain.find(node: coordinate) {
                
                if let terrainLayer = terrainNode.topLayer {
                    
                    terrainLayer.set(height: 0, corner: .northWest)
                    terrainLayer.set(height: 0, corner: .northEast)
                    terrainLayer.set(height: 0, corner: .southEast)
                    terrainLayer.set(height: 0, corner: .southWest)
                }
            }
        }
        
        for z in 0..<10 {
            
            let coordinate = Coordinate(x: 1, y: World.floor + 2, z: z)
         
            _ = meadow.footpaths.add(node: coordinate)
        }
        
        if let waterNode = meadow.water.add(node: Coordinate(x: 9, y: World.floor, z: 9)) {
            
            waterNode.waterLevel = (World.floor + 4)
        }
    }
}

extension SceneViewController: GridObserver {
    
    func child(didBecomeDirty child: SceneGraphChild) {
        
        observer?.child(didBecomeDirty: child)
    }
}
