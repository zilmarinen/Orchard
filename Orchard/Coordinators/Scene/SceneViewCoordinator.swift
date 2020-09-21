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
        
        let scene = Scene(meadow: meadow)
        
        controller._sceneView.scene = scene
        controller._sceneView.delegate = scene
        controller._sceneView.allowsCameraControl = true
        controller._sceneView.showsStatistics = true
        controller._sceneView.backgroundColor = meadow.backgroundColor.color
        controller._sceneView.autoenablesDefaultLighting = true
        controller._sceneView.isPlaying = true
        
        scene.camera.observer.focus(node: scene.meadow)
        
        //
        /// TODO : remove all code below this line
        //
        
        guard let totalQuads = scene.meadow.terrain.graph?.totalQuads else { return }

        for index in 0..<totalQuads {

            let bodyOfWater = (index > 20 && index < 50)
            let area = (index < 20)
            let footpath = (index > 50 && index < 80)
            let foliage = (index > 80 && index < 90)

            scene.meadow.terrain.add(tile: index)?.children.forEach { child in

                if let child = child as? TerrainEdge {

                    child.topLayer?.terrainType = .bedrock

                    let _ = child.addLayer()

                    child.topLayer?.terrainType = .grass
                    child.topLayer?.set(elevation: (bodyOfWater ? 2 : 4))
                }
            }

            if bodyOfWater {

                scene.meadow.water.add(tile: index)?.children.forEach { child in

                    if let child = child as? WaterEdge {

                        child.topLayer?.set(elevation: 4)
                    }
                }
            }

            if area {

                scene.meadow.area.add(tile: index)?.children.forEach { child in

                    if let child = child as? AreaEdge {

                        child.topLayer?.set(elevation: 4)
                    }
                }
            }

            if footpath {

                scene.meadow.footpath.add(tile: index)?.children.forEach { child in

                    if let child = child as? FootpathEdge {

                        child.topLayer?.set(elevation: 4)
                    }
                }
            }

//            if foliage {
//
//                if let tile = scene.meadow.foliage.add(tile: index) {
//
//                    //
//                }
//            }
        }
    }
}

extension SceneViewCoordinator: SceneGraphObserver {
    
    func focus(node: SceneGraphNode) {
        
        guard let scene = scene else { return }
        
        controller._sceneView.backgroundColor = scene.meadow.backgroundColor.color
        
        if let node = node as? SCNNode {
            
            scene.camera.observer.focus(node: node)
        }
        else if let node = node as? Tile {
            
            scene.camera.observer.focus(vector: SCNVector3(vector: node.centre))
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
