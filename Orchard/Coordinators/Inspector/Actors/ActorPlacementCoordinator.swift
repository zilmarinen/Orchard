//
//  ActorPlacementCoordinator.swift
//
//  Created by Zack Brown on 28/03/2021.
//

import Cocoa
import Harvest
import Meadow

class ActorPlacementCoordinator: ActorCoordinator, MouseObservable {
    
    var mouseObserver: UUID?
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        subscribeToMouseEvents(tracksIdleEvents: true)
        
        guard controller.isViewLoaded else { return }
        
        refresh()
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        unsubscribeFromMouseEvents()
        
        super.stop(then: completion)
    }
    
    override func refresh() {
        
        guard let actors = editor?.harvest.actors else { return }
        
        controller.gridRenderingButton.state = actors.isHidden ? .off : .on
        controller.nodeCountLabel.integerValue = actors.npcs.count
                 
        controller.nodeBox.isHidden = true
        controller.placementBox.isHidden = false
    }
}

extension ActorPlacementCoordinator {
    
    func stateDidChange(from previousState: SpriteView.MouseState?, to currentState: SpriteView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self,
                  let spriteView = self.spriteView,
                  let map = spriteView.scene as? Scene2D else { return }
            
            switch currentState {
            
            case .up(let position, let clickType):
                
                let startHit = map.hitTest(point: position.start)
                
                switch clickType {
                
                case .right:
                    
                    let endHit = map.hitTest(point: position.end)
                    
                    let bounds = GridBounds(start: startHit, end: endHit)
                    
                    bounds.enumerate(y: 0) { coordinate in
                    
                        map.harvest.actors.remove(actor: coordinate)
                    }
                    
                default:
                    
                    guard let surfaceTile = map.harvest.surface.find(tile: startHit) else { return }
                    
                    _ = map.harvest.actors.add(actor: surfaceTile.coordinate) { actor in
                        
                        //TODO: set actor properties
                    }
                }
                
            default: break
            }
            
            self.refresh()
        }
    }
}
