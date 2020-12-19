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
            
            case .tracking(let position, let clickType):
                
                guard let sceneView = self.sceneView,
                      let scene = sceneView.scene as? Scene,
                      let startHit = sceneView.hitTest(point: position.start, category: [.floor, .terrain, .terrainChunk]),
                      let endHit = sceneView.hitTest(point: position.end, category: [.floor, .terrain, .terrainChunk])else { return }
                
                let c0 = Coordinate(vector: startHit)
                let c1 = Coordinate(vector: endHit)
                print("c0: \(c0) - c1: \(c1)")
                let minimumX = min(c0.x, c1.x)
                let minimumZ = min(c0.y, c1.y)
                let maximumX = max(c0.x, c1.x)
                let maximumZ = max(c0.y, c1.y)
                
                for x in minimumX..<maximumX {
                    
                    for z in minimumZ..<maximumZ {
                        
                        
                    }
                }
                
            default: break
            }
        }
    }
}
