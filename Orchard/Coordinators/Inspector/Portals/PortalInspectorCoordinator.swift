//
//  PortalInspectorCoordinator.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Cocoa
import Meadow

class PortalInspectorCoordinator: PortalCoordinator, MouseObservable {
    
    var mouseObserver: UUID?
    
    weak var portal: Portal2D?
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        subscribeToMouseEvents(tracksIdleEvents: false)
        
        guard let option = option as? PortalUtilityCoordinator.ViewState,
              case let .inspector(node) = option else { return }
        
        portal = node
        
        guard controller.isViewLoaded else { return }
        
        refresh()
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        portal = nil
        
        unsubscribeFromMouseEvents()
        
        super.stop(then: completion)
    }
    
    override func refresh() {
        
        guard let portals = editor?.portals,
              let portal = portal else { return }
        
        controller.gridRenderingButton.state = portals.isHidden ? .off : .on
        controller.nodeCountLabel.integerValue = portals.portals.count
                 
        controller.nodeBox.isHidden = false
        controller.buildBox.isHidden = true
        
        controller.nodeRenderingButton.state = portal.isHidden ? .off : .on
        controller.nodeCoordinateView.coordinate = portal.footprint.coordinate
    }
}

extension PortalInspectorCoordinator {
    
    func stateDidChange(from previousState: SpriteView.MouseState?, to currentState: SpriteView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self,
                  let spriteView = self.spriteView,
                  let map = spriteView.scene as? Map else { return }
            
            switch currentState {
            
            case .up(let position, _):
                
                let hit = map.hitTest(point: position.end)
                
                guard let node = map.meadow.portals.find(portal: hit) else { return }
                
                self.toggle(inspector: .surface, with: PortalUtilityCoordinator.ViewState.inspector(node: node))
                
            default: break
            }
        }
    }
}


