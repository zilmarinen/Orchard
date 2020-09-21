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

extension AreaInspectorCoordinator {
    
    func stateDidChange(from previousState: SceneView.CursorState?, to currentState: SceneView.CursorState) {
        
        DispatchQueue.main.async {
            
            switch currentState {
                
            case .down(let position, _):
                
                if let hit = self.sceneView?.hitTest(point: position.start, category: .area),
                    let quad = hit.quad,
                    let node = self.sceneView?.scene?.meadow.area.find(tile: quad.i) {
                    
                    self.didSelect(node: node)
                }
                
            default: break
            }
        }
    }
}
