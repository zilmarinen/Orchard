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

extension Meadow: StartOption {
    
}

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
        
        super.start(with: option)
        
        meadow.floor.rendersGridLines = true
        
        let camera = SCNCamera()
        
        camera.usesOrthographicProjection = true
        camera.orthographicScale = 15
        
        let cameraNode = SCNNode()
        
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 5.0, y: CGFloat(World.Axis.y(y: World.Constants.ceiling)), z: 10.0)
        cameraNode.look(at: SCNVector3(x: 0.0, y: 0.0, z: 0.0))
        
        controller.sceneView.scene = SCNScene()
        controller.sceneView.delegate = meadow
        controller.sceneView.allowsCameraControl = true
        controller.sceneView.showsStatistics = true
        controller.sceneView.backgroundColor = .black
        controller.sceneView.autoenablesDefaultLighting = true
        controller.sceneView.isPlaying = true
        
        controller.sceneView.scene?.rootNode.addChildNode(meadow)
        controller.sceneView.scene?.rootNode.addChildNode(cameraNode)
        
        let node = SCNNode(geometry: SCNBox(width: 0.5, height: 1, length: 0.5, chamferRadius: 0))
        
        node.position = SCNVector3(x: 0.0, y: 0.5, z: 0.0)
        
        controller.sceneView.scene?.rootNode.addChildNode(node)
        /*
        for x in 0..<2 {
            
            for z in 0..<2 {
        
                meadow.terrain.add(tile: Coordinate(x: x, y: 0, z: z)) { layer in
        
                    layer.color = TerrainLayer.Color(primary: .systemPink, secondary: .systemOrange)
                }
            }
        }*/
    }
}
