//
//  TerrainAdjustUtilityCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 16/12/2020.
//

import Cocoa
import Meadow

class TerrainAdjustUtilityCoordinator: Coordinator<TerrainAdjustUtilityViewController>, MouseObservable {
    
    var mouseObserver: UUID?
    
    override init(controller: TerrainAdjustUtilityViewController) {
        
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

extension TerrainAdjustUtilityCoordinator {
    
    func stateDidChange(from previousState: SceneView.MouseState?, to currentState: SceneView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            switch currentState {
            
            case .idle(let position):
                
                guard let sceneView = self.sceneView,
                      let scene = sceneView.scene as? Scene,
                      let hit = sceneView.hitTest(point: position, category: [.floor, .terrain, .terrainChunk]) else { return }
                
                let bounds = GridBounds(start: Coordinate(vector: hit), end: Coordinate(vector: hit))
                let elevation = self.controller.elevationStepper.integerValue
                
                scene.meadow.blueprint.controller.select(terrain: bounds, blueprintType: .select, elevation: elevation)
            
            case .tracking(let position, _):
                
                guard let sceneView = self.sceneView,
                      let scene = sceneView.scene as? Scene,
                      let startHit = sceneView.hitTest(point: position.start, category: [.floor, .terrain, .terrainChunk]),
                      let endHit = sceneView.hitTest(point: position.end, category: [.floor, .terrain, .terrainChunk]) else { return }
                
                let bounds = GridBounds(start: Coordinate(vector: startHit), end: Coordinate(vector: endHit))
                let elevation = self.controller.elevationStepper.integerValue
                
                scene.meadow.blueprint.controller.select(terrain: bounds, blueprintType: .select, elevation: elevation)
            
            case .up(let position, _):
                
                guard let sceneView = self.sceneView,
                      let scene = sceneView.scene as? Scene,
                      let startHit = sceneView.hitTest(point: position.start, category: [.floor, .terrain, .terrainChunk]),
                      let endHit = sceneView.hitTest(point: position.end, category: [.floor, .terrain, .terrainChunk]) else { return }
                
                let bounds = GridBounds(start: Coordinate(vector: startHit), end: Coordinate(vector: endHit))
                let elevation = self.controller.elevationStepper.integerValue
                
                bounds.enumerate(y: elevation) { coordinate in
                    
                    if let tile = scene.meadow.terrain.find(tile: coordinate) {
                        
                        tile.coordinate = Coordinate(x: tile.coordinate.x, y: elevation, z: tile.coordinate.z)
                    }
                }
                
                scene.meadow.blueprint.controller.clear()
                
            default: break
            }
        }
    }
}
