//
//  TerrainBuildUtilityCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 05/11/2020.
//

import Cocoa
import Meadow

class TerrainBuildUtilityCoordinator: Coordinator<TerrainBuildUtilityViewController>, MouseObservable {
    
    var mouseObserver: UUID?
    
    override init(controller: TerrainBuildUtilityViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: SceneGraphNode?) {
        
        super.start(with: option)
        
        subscribeToMouseEvents()
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        unsubscribeFromMouseEvents()
        
        super.stop(then: completion)
    }
}

extension TerrainBuildUtilityCoordinator {
    
    func stateDidChange(from previousState: SceneView.MouseState?, to currentState: SceneView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            switch currentState {
            
            case .up(let position, let clickType):
                
                guard let sceneView = self.sceneView,
                      let scene = sceneView.scene as? Scene,
                      let tileType = TerrainTileType(rawValue: self.controller.typePopUp.indexOfSelectedItem),
                      let startHit = sceneView.hitTest(point: position.start, category: [.floor, .terrain, .terrainChunk]),
                      let endHit = sceneView.hitTest(point: position.end, category: [.floor, .terrain, .terrainChunk]) else { return }
                
                let selection = Selection(start: Coordinate(vector: startHit), end: Coordinate(vector: endHit))
                
                print("selected:")
                print("min: [\(selection.start.x), \(selection.start.z)]")
                print("max: [\(selection.end.x), \(selection.end.z)]")
                
                for x in selection.start.x..<selection.end.x {
                    
                    for z in selection.start.z..<selection.end.z {
                        
                        let coordinate = Coordinate(x: x, y: self.controller.elevationStepper.integerValue, z: z)
                        
                        switch clickType {
                        
                        case .left:
                            
                            _ = scene.meadow.terrain.add(tile: coordinate) { tile in
                                
                                tile.tileType = tileType
                            }
                            
                        case .right:
                            
                            scene.meadow.terrain.remove(tile: coordinate)
                            
                        default: break
                        }
                    }
                }
                
            default: break
            }
        }
    }
}
