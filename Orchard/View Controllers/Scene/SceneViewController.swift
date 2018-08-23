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
        sceneView.isPlaying = true
        sceneView.autoenablesDefaultLighting = true
        //return
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
                    
                    terrainLayer.set(height: 2)
                }
            }
        }

        let c0 = ColorPalettes.shared.palette(named: "Bedrock")!
        let c1 = ColorPalettes.shared.palette(named: "Sand")!
        
        let areaType = AreaType.concrete
        let architectureType = AreaArchitectureType.american
        
        for x in 3..<7 {
                
            for z in 3..<7 {
                
                let coordinate = Coordinate(x: x, y: World.floor + 2, z: z)
                
                if let areaNode = meadow.areas.add(node: coordinate) {
                    
                    areaNode.floorColorPalette = ColorPalettes.shared.all.last
                    areaNode.internalAreaType = areaType
                    areaNode.externalAreaType = areaType
                    
                    if x == 3{
                        
                        areaNode.set(edge: AreaNode.Edge(edge: .east, edgeType: .windowHalfWidth, architectureType: architectureType, externalColorPalette: c0, internalColorPalette: c1))
                    }
                    
                    if x == 6 && z != 5 {
                        
                        areaNode.set(edge: AreaNode.Edge(edge: .west, edgeType: .windowFullWidth, architectureType: architectureType, externalColorPalette: c0, internalColorPalette: c1))
                    }
                    
                    if z == 3 {
                        
                        areaNode.set(edge: AreaNode.Edge(edge: .south, edgeType: .wall, architectureType: architectureType, externalColorPalette: c0, internalColorPalette: c1))
                    }
                    
                    if z == 6 {
                        
                        areaNode.set(edge: AreaNode.Edge(edge: .north, edgeType: .wall, architectureType: architectureType, externalColorPalette: c0, internalColorPalette: c1))
                    }
                }
            }
        }
        
        if let areaNode = meadow.areas.add(node: Coordinate(x: 7, y: World.floor + 2, z: 5)) {
            
            areaNode.floorColorPalette = ColorPalettes.shared.all.last
            areaNode.internalAreaType = areaType
            areaNode.externalAreaType = areaType
            
            areaNode.set(edge: AreaNode.Edge(edge: .north, edgeType: .wall, architectureType: architectureType, externalColorPalette: c0, internalColorPalette: c1))
            areaNode.set(edge: AreaNode.Edge(edge: .south, edgeType: .wall, architectureType: architectureType, externalColorPalette: c0, internalColorPalette: c1))
            areaNode.set(edge: AreaNode.Edge(edge: .west, edgeType: .doorWithTransom, architectureType: architectureType, externalColorPalette: c0, internalColorPalette: c1))
            
            meadow.cameraJib.stateMachine.state = .focus(SCNVector3(x: MDWFloat(areaNode.volume.coordinate.x), y: Axis.Y(y: areaNode.volume.coordinate.y), z: MDWFloat(areaNode.volume.coordinate.z)), .north, 5.0)
        }
        
        for z in 0..<10 {
            
            let coordinate = Coordinate(x: 1, y: World.floor + 2 + (z == 4 ? 1 : 0), z: z)
         
            if let footpathNode = meadow.footpaths.add(node: coordinate) {
                
                if coordinate.z == 1 {
                 
                    footpathNode.slope = FootpathNode.Slope(edge: .north, steep: false)
                }
            }
        }
        
        let _ = meadow.footpaths.add(node: Coordinate(x: 0, y: World.floor + 2, z: 8))
        let _ = meadow.footpaths.add(node: Coordinate(x: 2, y: World.floor + 2, z: 8))
        let _ = meadow.footpaths.add(node: Coordinate(x: 3, y: World.floor + 2, z: 8))
        let _ = meadow.footpaths.add(node: Coordinate(x: 2, y: World.floor + 2, z: 9))
        
        if let waterNode = meadow.water.add(node: Coordinate(x: 9, y: World.floor, z: 9)) {
            
            //waterNode.waterLevel = (World.floor + 4)
        }
    }
}

extension SceneViewController: GridObserver {
    
    func child(didBecomeDirty child: SceneGraphChild) {
        
        observer?.child(didBecomeDirty: child)
    }
}
