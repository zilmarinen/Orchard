//
//  FoliageBuildUtilityCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 07/12/2020.
//

import Cocoa
import Meadow

class FoliageBuildUtilityCoordinator: Coordinator<FoliageBuildUtilityViewController>, MouseObservable {
    
    var mouseObserver: UUID?
    
    override init(controller: FoliageBuildUtilityViewController) {
        
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

extension FoliageBuildUtilityCoordinator {
    
    func stateDidChange(from previousState: SceneView.MouseState?, to currentState: SceneView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            switch currentState {
            
            case .idle(let position):
                
                guard let sceneView = self.sceneView,
                      let scene = sceneView.scene as? Scene,
                      let hit = sceneView.hitTest(point: position, category: [.terrain, .terrainChunk]) else { return }
                
                let bounds = GridBounds(start: Coordinate(vector: hit), end: Coordinate(vector: hit))
                
                scene.meadow.blueprint.controller.select(foliage: bounds, blueprintType: .select)
            
            case .tracking(let position, let clickType):
                
                guard let sceneView = self.sceneView,
                      let scene = sceneView.scene as? Scene,
                      let startHit = sceneView.hitTest(point: position.start, category: [.terrain, .terrainChunk]),
                      let endHit = sceneView.hitTest(point: position.end, category: [.terrain, .terrainChunk]) else { return }
                
                let bounds = GridBounds(start: Coordinate(vector: startHit), end: Coordinate(vector: endHit))
                let blueprintType: Blueprint.BlueprintType = clickType == .left ? .add : .remove
                
                scene.meadow.blueprint.controller.select(foliage: bounds, blueprintType: blueprintType)
            
            case .up(let position, let clickType):
                
                guard let sceneView = self.sceneView,
                      let scene = sceneView.scene as? Scene,
                      let tileType = FoliageTileType(rawValue: self.controller.typePopUp.indexOfSelectedItem),
                      let startHit = sceneView.hitTest(point: position.start, category: [.terrain, .terrainChunk]),
                      let endHit = sceneView.hitTest(point: position.end, category: [.terrain, .terrainChunk]) else { return }
                
                let bounds = GridBounds(start: Coordinate(vector: startHit), end: Coordinate(vector: endHit))
                
                switch clickType {
                
                case .left:
                    
                    _ = scene.meadow.foliage.add(tile: bounds.start)
                    
                case .right:
                    
                    scene.meadow.foliage.remove(tile: bounds.start)
                    
                default: break
                }
                
                scene.meadow.blueprint.controller.clear()
                
            default: break
            }
        }
    }
}
