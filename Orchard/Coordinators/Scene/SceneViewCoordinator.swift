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
        
        let width = 5
        let depth = 5
        
        for x in 0..<width {
            
            for z in 0..<depth {
                
                let coordinate = Coordinate(x: x, y: 0, z: z)
                
                meadow.terrain.add(tile: coordinate).children.forEach { edge in
                
                    if let edge = edge as? TerrainEdge {
                        
                        edge.topLayer?.set(elevation: 1)
                        edge.topLayer?.terrainType = .bedrock
                        
                        let _ = edge.addLayer()
                        
                        edge.topLayer?.set(elevation: 2)
                        edge.topLayer?.terrainType = .grass
                    }
                }
                
                if x >= 1 && x < (width - 1) && z >= 1 && z < (depth - 1) {

                    meadow.water.add(tile: coordinate).children.forEach { edge in
                        
                        if let edge = edge as? WaterEdge {
                            
                            edge.topLayer?.set(elevation: 3)
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
