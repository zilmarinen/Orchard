//
//  SceneViewCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 20/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Pasture
import Terrace
import SceneKit

class SceneViewCoordinator: Coordinator<SceneViewController> {
    
    override init(controller: SceneViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {

        guard let meadow = option as? Meadow else { fatalError("Invalid start option for scene view.") }
        
        meadow.floor.rendersGridLines = true
        
        let scene = Scene(meadow: meadow)
        
        controller.sceneView.scene = scene
        controller.sceneView.delegate = scene
        controller.sceneView.allowsCameraControl = true
        controller.sceneView.showsStatistics = true
        controller.sceneView.backgroundColor = .black
        controller.sceneView.autoenablesDefaultLighting = true
        controller.sceneView.isPlaying = true
        
        scene.camera.observer.focus(node: scene.meadow)
        
        /*
        let width = [0, 1, 2, 3, 4]
        let depth = [0, 1, 2, 3, 4]
        
        for x in width {
            
            for z in depth {
            
                let coordinate = Coordinate(x: x, y: 0, z: z)
                
                meadow.terrain.add(tile: coordinate).children.forEach { edge in
                
                    if let edge = edge as? TerrainEdge {
                        
                        edge.topLayer?.set(elevation: 1)
                        edge.topLayer?.terrainType = .bedrock
                        
                        let _ = edge.addLayer()

                        edge.topLayer?.set(elevation: 2)
                        edge.topLayer?.terrainType = .dirt

                        let _ = edge.addLayer()

                        edge.topLayer?.set(elevation: 3)
                        edge.topLayer?.terrainType = .grass
                    }
                }
                
                meadow.water.add(tile: coordinate).children.forEach { edge in

                    if let edge = edge as? WaterEdge {

                        edge.topLayer?.set(elevation: 5)
                    }
                }
            }
        }*/
        
        let width = 7
        let depth = 7
        
        for x in 0..<width {
            
            for z in 0..<depth {
                
                let coordinate = Coordinate(x: x, y: 0, z: z)
                
                meadow.terrain.add(tile: coordinate).children.forEach { edge in
                
                    if let edge = edge as? TerrainEdge {
                        
                        edge.topLayer?.set(elevation: 1)
                        edge.topLayer?.terrainType = .bedrock
                        
                        let _ = edge.addLayer()

                        edge.topLayer?.set(elevation: 2)
                        edge.topLayer?.terrainType = .dirt
                        
                        if x != 3 {
                            
                            let _ = edge.addLayer()

                            edge.topLayer?.set(elevation: (z >= 4 ? 10 : 4))
                            edge.topLayer?.terrainType = .grass
                        }
                    }
                }
                
                if x == 3 {
                    
                    meadow.water.add(tile: coordinate).children.forEach { edge in

                        if let edge = edge as? WaterEdge {

                            edge.topLayer?.set(elevation: (z >= 4 ? 10 : 4))
                        }
                    }
                }
                
                if (x > 0 && (x + 1) < width) && z == 1 {
                    
                    meadow.footpath.add(tile: coordinate).children.forEach { edge in
                        
                        if let edge = edge as? FootpathEdge {
                            
                            edge.topLayer?.set(elevation: 4)
                        }
                    }
                }
            }
        }
    }
}

extension SceneViewCoordinator: SceneGraphObserver {
    
    func focus(node: SceneGraphNode) {
        
        guard let scene = controller.sceneView.scene as? Scene else { return }
        
        if let node = node as? SCNNode {
            
            scene.camera.observer.focus(node: node)
        }
        
        var items: [NSPathControlItem] = []
        
        if let node = node as? Soilable {
        
            var child: Soilable? = node
            
            while child != nil {
                
                guard let identifiable = child as? SceneGraphIdentifiable else { continue }
            
                let item = NSPathControlItem()
                
                item.title = identifiable.name ?? "Meadow"
                item.image = identifiable.image
                
                items.append(item)
                
                child = child?.ancestor as? Soilable
            }
        }
        
        controller.pathControl.pathItems = items.reversed()
    }
}
