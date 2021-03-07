//
//  BuildingsBuildUtilityCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 01/02/2021.
//

import Cocoa
import Meadow

class BuildingsBuildUtilityCoordinator: Coordinator<BuildingsBuildUtilityViewController>, MouseObservable {
    
    var mouseObserver: UUID?
    
    override init(controller: BuildingsBuildUtilityViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: SceneGraphNode?) {
        
        super.start(with: option)
        
        subscribeToMouseEvents(tracksIdleEvents: true)
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        unsubscribeFromMouseEvents()
        
        super.stop(then: completion)
    }
}

extension BuildingsBuildUtilityCoordinator {
    
    func stateDidChange(from previousState: SceneView.MouseState?, to currentState: SceneView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            switch currentState {
            
            case .idle(let position):
                
                guard let sceneView = self.sceneView,
                      let scene = sceneView.scene as? Scene,
                      let hit = sceneView.hitTest(point: position, category: [.buildings, .buildingChunk, .terrain, .terrainChunk]) else { return }
                
                let bounds = GridBounds(start: Coordinate(vector: hit), end: Coordinate(vector: hit))
                
                scene.meadow.blueprint.controller.select(footpath: bounds, blueprintType: .select)
                
            case .tracking(let position, let clickType):
                
                guard let sceneView = self.sceneView,
                      let scene = sceneView.scene as? Scene,
                      let hit = sceneView.hitTest(point: position.start, category: [.buildings, .buildingChunk, .terrain, .terrainChunk]) else { return }
                
                let bounds = GridBounds(start: Coordinate(vector: hit), end: Coordinate(vector: hit))
                let blueprintType: Blueprint.BlueprintType = clickType == .left ? .add : .remove
                
                scene.meadow.blueprint.controller.select(building: bounds, blueprintType: blueprintType)
            
            case .up(let position, let clickType):
                
                guard let sceneView = self.sceneView,
                      let scene = sceneView.scene as? Scene,
                      let hit = sceneView.hitTest(point: position.start, category: [.buildings, .buildingChunk, .terrain, .terrainChunk]) else { return }
                
                let bounds = GridBounds(start: Coordinate(vector: hit), end: Coordinate(vector: hit))
                
                bounds.enumerate(y: 0) { coordinate in
                    
                    switch clickType {
                    
                    case .left:
                        
                        guard let terrainTile = scene.meadow.terrain.find(tile: coordinate) else { break }
                        
                        _ = scene.meadow.buildings.add(layer: terrainTile.coordinate) { layer in
                            
                            let tile = layer.ancestor as? BuildingTile
                            
                            tile?.slope = terrainTile.slope
                        }
                    
                    case .right:
                        
                        if let tile = scene.meadow.buildings.find(tile: coordinate) {
                            
                            scene.meadow.buildings.remove(layer: coordinate, at: tile.childCount - 1)
                        }
                        
                    default: break
                    }
                }
                
                scene.meadow.blueprint.controller.clear()
                
            default: break
            }
        }
    }
}
