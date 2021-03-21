//
//  PortalBuildCoordinator.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Cocoa
import Meadow

class PortalBuildCoordinator: PortalCoordinator, MouseObservable {
    
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
        
        guard let portals = editor?.portals else { return }
        
        controller.gridRenderingButton.state = portals.isHidden ? .off : .on
        controller.nodeCountLabel.integerValue = portals.portals.count
                 
        controller.nodeBox.isHidden = false
        controller.buildBox.isHidden = true
    }
}

extension PortalBuildCoordinator {
    
    func stateDidChange(from previousState: SpriteView.MouseState?, to currentState: SpriteView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self,
                  let spriteView = self.spriteView,
                  let map = spriteView.scene as? Map else { return }
            
            switch currentState {
            
            case .up(let position, let clickType):
                
                let startHit = map.hitTest(point: position.start)
                let endHit = map.hitTest(point: position.end)
                
                let bounds = GridBounds(start: startHit, end: endHit)
                
                bounds.enumerate(y: 0) { coordinate in
                    
                    switch clickType {
                    
                    case .right:
                        
                        map.meadow.portals.remove(portal: coordinate)
                        
                    default:
                        
                        print("Left")
                    }
                }
                
            default: break
            }
            
            self.refresh()
        }
    }
}
