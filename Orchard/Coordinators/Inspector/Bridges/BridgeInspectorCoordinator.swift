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
    
    weak var tile: BridgeTile2D?
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        subscribeToMouseEvents(tracksIdleEvents: false)
        
        guard let option = option as? BridgeUtilityCoordinator.ViewState,
              case let .inspector(node) = option else { return }
        
        tile = node
        
        guard controller.isViewLoaded else { return }
        
        refresh()
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        tile = nil
        
        unsubscribeFromMouseEvents()
        
        super.stop(then: completion)
    }
    
    override func refresh() {
        
        guard let buildings = editor?.map.buildings,
              let tile = tile else { return }
        
        controller.gridRenderingButton.state = buildings.isHidden ? .off : .on
        controller.chunkCountLabel.integerValue = buildings.chunks.count
                 
        controller.tileBox.isHidden = false
        controller.buildBox.isHidden = true
        
        controller.tileRenderingButton.state = tile.isHidden ? .off : .on
        controller.nodeCoordinateView.coordinate = tile.coordinate
    }
}

extension BridgeInspectorCoordinator {
    
    func stateDidChange(from previousState: SpriteView.MouseState?, to currentState: SpriteView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self,
                  let spriteView = self.spriteView,
                  let scene = spriteView.scene as? Scene2D else { return }
            
            switch currentState {
            
            case .up(let position, _):
                
                let hit = scene.hitTest(point: position.end)
                
                guard let node = scene.map.bridges.find(tile: hit) else { return }
                
                self.toggle(inspector: .bridge, with: BridgeUtilityCoordinator.ViewState.inspector(node: node))
                
            default: break
            }
        }
    }
}
