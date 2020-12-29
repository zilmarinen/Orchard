//
//  PortalBuildUtilityCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 09/12/2020.
//

import Cocoa
import Meadow

class PortalBuildUtilityCoordinator: Coordinator<PortalBuildUtilityViewController>, MouseObservable {
    
    var mouseObserver: UUID?
    
    override init(controller: PortalBuildUtilityViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: SceneGraphNode?) {
        
        super.start(with: option)
        
        subscribeToMouseEvents(tracksIdleEvents: false)
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        unsubscribeFromMouseEvents()
        
        super.stop(then: completion)
    }
}

extension PortalBuildUtilityCoordinator {
    
    func stateDidChange(from previousState: SceneView.MouseState?, to currentState: SceneView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            switch currentState {
            
            case .tracking(let position, let clickType):
                
                guard let sceneView = self.sceneView,
                      let scene = sceneView.scene as? Scene,
                      let startHit = sceneView.hitTest(point: position.start, category: [.floor, .portals, .portal]),
                      let endHit = sceneView.hitTest(point: position.end, category: [.floor, .portals, .portal]) else { return }
                
                let bounds = GridBounds(start: Coordinate(vector: startHit), end: Coordinate(vector: endHit))
                let blueprintType: Blueprint.BlueprintType = clickType == .left ? .add : .remove
                
                scene.meadow.blueprint.controller.select(portal: bounds, blueprintType: blueprintType)
            
            case .up(let position, let clickType):
                
                guard let sceneView = self.sceneView,
                      let scene = sceneView.scene as? Scene,
                      let startHit = sceneView.hitTest(point: position.start, category: [.floor, .portals, .portal]),
                      let endHit = sceneView.hitTest(point: position.end, category: [.floor, .portals, .portal]) else { return }
                
                scene.meadow.blueprint.controller.clear()
                
            default: break
            }
        }
    }
}
