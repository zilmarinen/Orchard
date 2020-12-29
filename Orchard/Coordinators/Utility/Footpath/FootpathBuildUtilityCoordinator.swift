//
//  FootpathBuildUtilityCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 03/12/2020.
//

import Cocoa
import Meadow

class FootpathBuildUtilityCoordinator: Coordinator<FootpathBuildUtilityViewController>, MouseObservable {
    
    var mouseObserver: UUID?
    
    override init(controller: FootpathBuildUtilityViewController) {
        
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

extension FootpathBuildUtilityCoordinator {
    
    func stateDidChange(from previousState: SceneView.MouseState?, to currentState: SceneView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            switch currentState {
            
            case .idle(let position):
                
                guard let sceneView = self.sceneView,
                      let scene = sceneView.scene as? Scene,
                      let hit = sceneView.hitTest(point: position, category: [.floor, .footpath, .footpathChunk]) else { return }
                
                let bounds = GridBounds(start: Coordinate(vector: hit), end: Coordinate(vector: hit))
                
                scene.meadow.blueprint.controller.select(footpath: bounds, blueprintType: .select)
                
            case .tracking(let position, let clickType):
                
                guard let sceneView = self.sceneView,
                      let scene = sceneView.scene as? Scene,
                      let startHit = sceneView.hitTest(point: position.start, category: [.floor, .footpath, .footpathChunk]),
                      let endHit = sceneView.hitTest(point: position.end, category: [.floor, .footpath, .footpathChunk]) else { return }
                
                let bounds = GridBounds(start: Coordinate(vector: startHit), end: Coordinate(vector: endHit))
                let blueprintType: Blueprint.BlueprintType = clickType == .left ? .add : .remove
                
                scene.meadow.blueprint.controller.select(footpath: bounds, blueprintType: blueprintType)
            
            case .up(let position, let clickType):
                
                guard let sceneView = self.sceneView,
                      let scene = sceneView.scene as? Scene,
                      let tileType = FootpathTileType(rawValue: self.controller.typePopUp.indexOfSelectedItem),
                      let startHit = sceneView.hitTest(point: position.start, category: [.floor, .footpath, .footpathChunk]),
                      let endHit = sceneView.hitTest(point: position.end, category: [.floor, .footpath, .footpathChunk]) else { return }
                
                let bounds = GridBounds(start: Coordinate(vector: startHit), end: Coordinate(vector: endHit))
                
                bounds.enumerate(y: 0) { coordinate in
                    
                    switch clickType {
                    
                    case .left:
                        
                        guard let terrainTile = scene.meadow.terrain.find(tile: coordinate) else { break }
                    
                        _ = scene.meadow.footpath.add(tile: terrainTile.coordinate) { tile in
                            
                            tile.tileType = tileType
                            tile.slope = terrainTile.slope
                        }
                    
                    case .right:
                        
                        scene.meadow.footpath.remove(tile: coordinate)
                        
                    default: break
                    }
                }
                
                scene.meadow.blueprint.controller.clear()
                
            default: break
            }
        }
    }
}
