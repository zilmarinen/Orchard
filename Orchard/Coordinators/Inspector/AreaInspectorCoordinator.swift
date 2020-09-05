//
//  AreaInspectorCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 12/06/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

class AreaInspectorCoordinator: Coordinator<AreaInspectorViewController> {
    
    var cursorObserver: UUID? = nil
    
    override init(controller: AreaInspectorViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        guard let node = option as? SceneGraphIdentifiable else { fatalError("Invalid start option for Area Inspector Coordinator") }
        
        self.controller.inspector = AreaInspector(node: node)

        guard let sceneView = sceneView else { return }
        
        cursorObserver = sceneView.cursorObserver.subscribe(stateDidChange(from:to:))
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        if let cursorObserver = cursorObserver, let sceneView = sceneView {
            
            sceneView.cursorObserver.unsubscribe(cursorObserver)
        }
        
        self.controller.inspector = nil
        
        completion?()
    }
}

extension AreaInspectorCoordinator: StateHandler {
    
    func stateDidChange(from previousState: SceneView.CursorState?, to currentState: SceneView.CursorState) {
        
        DispatchQueue.main.async {
            
            guard let sceneView = self.sceneView else { return }
            
            switch currentState {
                
            case .down(let position, _):
                
                if let hit = sceneView.hitTest(point: position.start, category: SceneGraphNodeCategory.area), let quad = hit.quad, let node = sceneView.scene?.meadow.area.find(tile: quad.i) {
                    
                    self.didSelect(node: node)
                }
                
            default: break
            }
        }
    }
}
