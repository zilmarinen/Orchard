//
//  SceneViewCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 20/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
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
        
        let n0 = SCNNode(geometry: SCNBox(width: 0.5, height: 1, length: 0.5, chamferRadius: 0))
        let n1 = SCNNode(geometry: SCNBox(width: 0.5, height: 1, length: 0.5, chamferRadius: 0))
        let n2 = SCNNode(geometry: SCNBox(width: 0.5, height: 1, length: 0.5, chamferRadius: 0))
        
        n0.position = SCNVector3(x: 0.0, y: 0.5, z: 0.0)
        n1.position = SCNVector3(x: 1.0, y: 0.5, z: 0.0)
        n2.position = SCNVector3(x: 2.0, y: 0.5, z: 0.0)
        
        n0.geometry?.firstMaterial?.diffuse.contents = MDWColor.systemPink
        n1.geometry?.firstMaterial?.diffuse.contents = MDWColor.systemOrange
        n2.geometry?.firstMaterial?.diffuse.contents = MDWColor.systemPurple
        
        controller.sceneView.scene?.rootNode.addChildNode(n0)
        controller.sceneView.scene?.rootNode.addChildNode(n1)
        controller.sceneView.scene?.rootNode.addChildNode(n2)
        
        scene.camera.observer.focus(node: n0)
        
        for x in 0..<2 {
            
            for z in 0..<2 {
        
                meadow.terrain.add(tile: Coordinate(x: x, y: 0, z: z)) { layer in
        
                    //layer.color = TerrainLayer.Color(primary: .systemPink, secondary: .systemOrange)
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
