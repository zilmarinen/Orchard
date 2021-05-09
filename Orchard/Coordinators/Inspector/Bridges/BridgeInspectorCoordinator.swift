//
//  BridgeInspectorCoordinator.swift
//
//  Created by Zack Brown on 30/03/2021.
//

import Cocoa
import Harvest
import Meadow

class BridgeInspectorCoordinator: BridgeCoordinator, MouseObservable {
    
    var mouseObserver: UUID?
    
    weak var chunk: BridgeChunk2D?
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        subscribeToMouseEvents(tracksIdleEvents: false)
        
        guard let option = option as? BridgeUtilityCoordinator.ViewState,
              case let .inspector(node) = option else { return }
        
        chunk = node
        
        guard controller.isViewLoaded else { return }
        
        refresh()
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        chunk = nil
        
        unsubscribeFromMouseEvents()
        
        super.stop(then: completion)
    }
    
    override func refresh() {
        
        guard let buildings = editor?.harvest.buildings,
              let chunk = chunk else { return }
        
        controller.gridRenderingButton.state = buildings.isHidden ? .off : .on
        controller.nodeCountLabel.integerValue = buildings.chunks.count
                 
        controller.nodeBox.isHidden = false
        controller.buildBox.isHidden = true
        
        controller.nodeRenderingButton.state = chunk.isHidden ? .off : .on
        controller.nodeCoordinateView.coordinate = chunk.footprint.coordinate
    }
}

extension BridgeInspectorCoordinator {
    
    func stateDidChange(from previousState: SpriteView.MouseState?, to currentState: SpriteView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self,
                  let spriteView = self.spriteView,
                  let map = spriteView.scene as? Scene2D else { return }
            
            switch currentState {
            
            case .up(let position, _):
                
                let hit = map.hitTest(point: position.end)
                
                guard let node = map.harvest.bridges.find(chunk: hit) else { return }
                
                self.toggle(inspector: .surface, with: BridgeUtilityCoordinator.ViewState.inspector(node: node))
                
            default: break
            }
        }
    }
}


