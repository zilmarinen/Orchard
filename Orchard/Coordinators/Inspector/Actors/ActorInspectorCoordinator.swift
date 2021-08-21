//
//  ActorInspectorCoordinator.swift
//
//  Created by Zack Brown on 28/03/2021.
//

import Cocoa
import Harvest
import Meadow

class ActorInspectorCoordinator: ActorCoordinator, MouseObservable {
    
    var mouseObserver: UUID?
    
    weak var actor: Actor2D?
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        subscribeToMouseEvents(tracksIdleEvents: false)
        
        guard let option = option as? ActorUtilityCoordinator.ViewState,
              case let .inspector(node) = option else { return }
        
        actor = node
        
        guard controller.isViewLoaded else { return }
        
        refresh()
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        actor = nil
        
        unsubscribeFromMouseEvents()
        
        super.stop(then: completion)
    }
    
    override func refresh() {
        
        guard let actors = editor?.map.actors,
              let actor = actor else { return }
        
        controller.gridRenderingButton.state = actors.isHidden ? .off : .on
        controller.nodeCountLabel.integerValue = actors.npcs.count
                 
        controller.nodeBox.isHidden = false
        controller.placementBox.isHidden = true
        
        controller.nodeRenderingButton.state = actor.isHidden ? .off : .on
        controller.nodeCoordinateView.coordinate = actor.coordinate
    }
}

extension ActorInspectorCoordinator {
    
    func stateDidChange(from previousState: SpriteView.MouseState?, to currentState: SpriteView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self,
                  let spriteView = self.spriteView,
                  let scene = spriteView.scene as? Scene2D else { return }
            
            switch currentState {
            
            case .up(let position, _):
                
                let hit = scene.hitTest(point: position.end)
                
                guard let node = scene.map.actors.find(actor: hit) else { return }
                
                self.toggle(inspector: .surface, with: ActorUtilityCoordinator.ViewState.inspector(node: node))
                
            default: break
            }
        }
    }
}


