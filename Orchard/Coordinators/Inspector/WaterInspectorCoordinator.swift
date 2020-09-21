//
//  WaterInspectorCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 12/06/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

class WaterInspectorCoordinator: Coordinator<WaterInspectorViewController> {
    
    var cursorObserver: UUID? = nil
    
    override init(controller: WaterInspectorViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        guard let node = option as? SceneGraphIdentifiable else { fatalError("Invalid start option for Water Inspector Coordinator") }
        
        self.controller.inspector = WaterInspector(node: node)
        
        cursorObserver = sceneView?.cursorObserver.subscribe(stateDidChange(from:to:))
    }
        
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        if let cursorObserver = cursorObserver {
            
            sceneView?.cursorObserver.unsubscribe(cursorObserver)
        }
        
        self.controller.inspector = nil
        
        completion?()
    }
}

extension WaterInspectorCoordinator {
    
    func stateDidChange(from previousState: SceneView.CursorState?, to currentState: SceneView.CursorState) {
        
        DispatchQueue.main.async {
            
            switch currentState {
                
            case .down(let position, _):
                
                guard let hit = self.sceneView?.hitTest(point: position.start, category: .water),
                    let quad = hit.quad,
                    let joint = hit.joint,
                    let node = self.sceneView?.scene?.meadow.water.find(tile: quad.i),
                    let layer = node.find(edge: joint.i)?.topLayer else { return }
                                
                self.didSelect(node: layer)
                
            default: break
            }
        }
    }
}
