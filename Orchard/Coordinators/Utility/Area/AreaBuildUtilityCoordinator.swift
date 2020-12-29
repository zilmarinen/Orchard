//
//  AreaBuildUtilityCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 08/12/2020.
//

import Cocoa
import Meadow

class AreaBuildUtilityCoordinator: Coordinator<AreaBuildUtilityViewController>, MouseObservable {
    
    var mouseObserver: UUID?
    
    override init(controller: AreaBuildUtilityViewController) {
        
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

extension AreaBuildUtilityCoordinator {
    
    func stateDidChange(from previousState: SceneView.MouseState?, to currentState: SceneView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            switch currentState {
            
            case .idle(let position):
                
                guard let sceneView = self.sceneView,
                      let scene = sceneView.scene as? Scene,
                      let hit = sceneView.hitTest(point: position, category: [.floor, .area, .areaChunk]) else { return }
                
                let bounds = GridBounds(start: Coordinate(vector: hit), end: Coordinate(vector: hit))
                let elevation = self.controller.elevationStepper.integerValue
                
                scene.meadow.blueprint.controller.select(area: bounds, blueprintType: .select, elevation: elevation)
            
            case .tracking(let position, let clickType):
                
                guard let sceneView = self.sceneView,
                      let scene = sceneView.scene as? Scene,
                      let startHit = sceneView.hitTest(point: position.start, category: [.floor, .area, .areaChunk]),
                      let endHit = sceneView.hitTest(point: position.end, category: [.floor, .area, .areaChunk]) else { return }
                
                let bounds = GridBounds(start: Coordinate(vector: startHit), end: Coordinate(vector: endHit))
                let blueprintType: Blueprint.BlueprintType = clickType == .left ? .add : .remove
                let elevation = self.controller.elevationStepper.integerValue
                
                scene.meadow.blueprint.controller.select(area: bounds, blueprintType: blueprintType, elevation: elevation)
            
            case .up(let position, let clickType):
                
                guard let sceneView = self.sceneView,
                      let scene = sceneView.scene as? Scene,
                      let tileType = AreaTileType(rawValue: self.controller.typePopUp.indexOfSelectedItem),
                      let startHit = sceneView.hitTest(point: position.start, category: [.floor, .area, .areaChunk]),
                      let endHit = sceneView.hitTest(point: position.end, category: [.floor, .area, .areaChunk]) else { return }
                
                let bounds = GridBounds(start: Coordinate(vector: startHit), end: Coordinate(vector: endHit))
                let elevation = self.controller.elevationStepper.integerValue
                
                bounds.enumerate(y: elevation) { coordinate in
                    
                    switch clickType {
                    
                    case .left:
                    
                        _ = scene.meadow.area.add(tile: coordinate) { tile in
                            
                            tile.tileType = tileType
                        }
                    
                    case .right:
                        
                        scene.meadow.area.remove(tile: coordinate)
                        
                    default: break
                    }
                }
                
                scene.meadow.blueprint.controller.clear()
                
            default: break
            }
        }
    }
}
