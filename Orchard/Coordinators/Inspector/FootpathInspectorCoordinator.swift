//
//  FootpathInspectorCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 12/06/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

class FootpathInspectorCoordinator: Coordinator<FootpathInspectorViewController> {
    
    var cursorObserver: UUID? = nil
    
    override init(controller: FootpathInspectorViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        guard let node = option as? SceneGraphIdentifiable else { fatalError("Invalid start option for Footpath Inspector Coordinator") }
        
        self.controller.inspector = FootpathInspector(node: node)

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

extension FootpathInspectorCoordinator: StateHandler {
    
    func stateDidChange(from previousState: SceneView.CursorState?, to currentState: SceneView.CursorState) {
        
        DispatchQueue.main.async {
            
            guard let sceneView = self.sceneView else { return }
            
            switch currentState {
                
            case .down(let position, _):
                
                guard let hit = sceneView.hitTest(point: position.start, category: SceneGraphNodeCategory.footpath),
                    let quad = hit.quad,
                    let joint = hit.joint,
                    let node = sceneView.scene?.meadow.footpath.find(tile: quad.i),
                    let layer = node.find(edge: joint.i)?.topLayer else { return }
                                
                self.didSelect(node: layer)
                
            default: break
            }
        }
    }
}
