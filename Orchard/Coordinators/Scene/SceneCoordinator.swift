//
//  SceneCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa
import Meadow
import SceneKit

class SceneCoordinator: Coordinator<SceneViewController> {
    
    override init(controller: SceneViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: SceneGraphNode?) {
        
        super.start(with: option)
        
        guard let scene = option as? Scene else { fatalError("Invalid start option") }
        
        controller.sceneView.backgroundColor = scene.backgroundColor.color
        controller.sceneView.scene = scene
        controller.sceneView.delegate = scene
        controller.sceneView.isPlaying = true
        controller.sceneView.allowsCameraControl = true
        controller.sceneView.autoenablesDefaultLighting = true
        
        focus(node: scene)
        
        scene.camera.camera?.usesOrthographicProjection = true
        scene.camera.position = SCNVector3(x: 20, y: 20, z: 20)
        scene.camera.look(at: SCNVector3(x: 4, y: 0, z: 4))
        scene.camera.camera?.focalLength = 100
        
        let width = 9
        let depth = 9
        
        let band0 = 2
        let baseType = TerrainTileType.dirt
        
        for x in 0..<width {
            
            for z in 0..<depth {
                
                var tileType = baseType.next
                
                if x < band0 || x >= (width - band0) || z < band0 || z >= (depth - band0) {
                    
                    tileType = baseType
                }
                
                let _ = scene.meadow.terrain.add(tile: Coordinate(x: x, y: 0, z: z), layer: tileType)
            }
        }
        
        let x = 3
        let z = 3
        
        //
        //
        //
        
        if let tile = scene.meadow.terrain.find(tile: Coordinate(x: x, y: 0, z: z)) {
            
            tile.layer.slope = .west
        }
        
        if let tile = scene.meadow.terrain.find(tile: Coordinate(x: x, y: 0, z: z + 1)) {
            
            tile.layer.slope = .west
        }
        
        //
        //
        //
        
        if let tile = scene.meadow.terrain.find(tile: Coordinate(x: x + 1, y: 0, z: z)) {
            
            tile.layer.slope = .west
            tile.coordinate = Coordinate(x: tile.coordinate.x, y: 1, z: tile.coordinate.z)
        }
        
        if let tile = scene.meadow.terrain.find(tile: Coordinate(x: x + 1, y: 0, z: z + 1)) {
            
            tile.layer.slope = .west
            tile.coordinate = Coordinate(x: tile.coordinate.x, y: 1, z: tile.coordinate.z)
        }
        
        //
        //
        //
        
        if let tile = scene.meadow.terrain.find(tile: Coordinate(x: x + 2, y: 0, z: z)) {
            
            tile.coordinate = Coordinate(x: tile.coordinate.x, y: 2, z: tile.coordinate.z)
        }
        
        if let tile = scene.meadow.terrain.find(tile: Coordinate(x: x + 2, y: 0, z: z + 1)) {
            
            tile.coordinate = Coordinate(x: tile.coordinate.x, y: 2, z: tile.coordinate.z)
        }
        
        //
        //
        //
        
        if let tile = scene.meadow.terrain.find(tile: Coordinate(x: x + 2, y: 0, z: z + 2)) {
            
            tile.coordinate = Coordinate(x: tile.coordinate.x, y: 2, z: tile.coordinate.z)
        }
        
        if let tile = scene.meadow.terrain.find(tile: Coordinate(x: x, y: 0, z: z + 2)) {
            
            tile.layer.slope = .west
        }
    }
}

extension SceneCoordinator {
    
    override func focus(node: SceneGraphNode) {
        
        var items: [NSPathControlItem] = []
        
        if let node = node as? (SceneGraphNode & Soilable) {
            
            var parent: (SceneGraphNode & Soilable)? = node
            
            while parent != nil {
                
                let item = NSPathControlItem()
                
                item.title = parent?.name ?? "Meadow"
                item.image = NSImage(named: "meadow_icon")
                
                items.append(item)
                
                parent = parent?.ancestor as? (SceneGraphNode & Soilable)
            }
        }
        
        guard let scene = controller.sceneView.scene as? Scene else { return }
        
        let item = NSPathControlItem()
        
        item.title = scene.name ?? "Scene"
        item.image = NSImage(named: "meadow_icon")
        
        items.append(item)
        
        controller.pathControl.pathItems = items.reversed()
    }
}
