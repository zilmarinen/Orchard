//
//  FoliageInspectorCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 12/06/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

class FoliageInspectorCoordinator: Coordinator<FoliageInspectorViewController> {
    
    var cursorObserver: UUID? = nil
    
    override init(controller: FoliageInspectorViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        guard let node = option as? SceneGraphIdentifiable else { fatalError("Invalid start option for Foliage Inspector Coordinator") }
        
        self.controller.inspector = FoliageInspector(node: node)
        
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

extension FoliageInspectorCoordinator {
    
    func stateDidChange(from previousState: SceneView.CursorState?, to currentState: SceneView.CursorState) {
        
        DispatchQueue.main.async {
            
            switch currentState {
                
            case .down(let position, _):
                
                if let hit = self.sceneView?.hitTest(point: position.start, category: .foliage),
                    let quad = hit.quad,
                    let node = self.sceneView?.scene?.meadow.foliage.find(tile: quad.i) {
                    
                    self.didSelect(node: node)
                }
                
            default: break
            }
        }
    }
}

