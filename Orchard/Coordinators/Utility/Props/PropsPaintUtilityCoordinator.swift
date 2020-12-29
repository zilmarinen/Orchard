//
//  PropsPaintUtilityCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 08/12/2020.
//

import Cocoa
import Meadow

class PropsPaintUtilityCoordinator: Coordinator<PropsPaintUtilityViewController>, MouseObservable {
    
    var mouseObserver: UUID?
    
    override init(controller: PropsPaintUtilityViewController) {
        
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

extension PropsPaintUtilityCoordinator {
    
    func stateDidChange(from previousState: SceneView.MouseState?, to currentState: SceneView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            switch currentState {
            
            case .tracking(let position, _):
                
                guard let sceneView = self.sceneView,
                      let scene = sceneView.scene as? Scene,
                      let startHit = sceneView.hitTest(point: position.start, category: [.floor, .props, .prop]),
                      let endHit = sceneView.hitTest(point: position.end, category: [.floor, .props, .prop]) else { return }
                
                let bounds = GridBounds(start: Coordinate(vector: startHit), end: Coordinate(vector: endHit))
                
                scene.meadow.blueprint.controller.select(prop: bounds, blueprintType: .select)
            
            case .up(let position, _):
                
                guard let sceneView = self.sceneView,
                      let scene = sceneView.scene as? Scene,
                      let startHit = sceneView.hitTest(point: position.start, category: [.floor, .props, .prop]),
                      let endHit = sceneView.hitTest(point: position.end, category: [.floor, .props, .prop]) else { return }
                
                scene.meadow.blueprint.controller.clear()
                
            default: break
            }
        }
    }
}
