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
        
        controller.sceneView.scene = scene
        controller.sceneView.delegate = scene
        controller.sceneView.allowsCameraControl = true
        controller.sceneView.showsStatistics = true
        controller.sceneView.backgroundColor = .black
        controller.sceneView.autoenablesDefaultLighting = true
        controller.sceneView.isPlaying = true
        
        scene.camera.observer.focus(node: scene.meadow)
        
        let n0 = SCNNode(geometry: SCNBox(width: 0.25, height: 1, length: 0.25, chamferRadius: 0))

        n0.position = SCNVector3(x: 0.0, y: CGFloat(World.Axis.y(value: World.Constants.floor + 4)) + 0.5, z: 0.0)
        n0.geometry?.firstMaterial?.diffuse.contents = SKColor.systemPink

        scene.rootNode.addChildNode(n0)
        
        guard let totalQuads = scene.meadow.terrain.graph?.totalQuads else { return }
        
        for index in 0..<totalQuads {
            
            let bodyOfWater = (index > 20 && index < 50)
            let abode = (index < 20)
            let footpath = (index > 50 && index < 70)
            let foliage = (index > 70 && index < 90)
         
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
            
            if abode {
                
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
