//
//  StairsInspectorCoordinator.swift
//
//  Created by Zack Brown on 30/03/2021.
//

import Cocoa
import Harvest
import Meadow

class StairsInspectorCoordinator: StairsCoordinator, MouseObservable {
    
    var mouseObserver: UUID?
    
    weak var tile: StairChunk2D?
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        subscribeToMouseEvents(tracksIdleEvents: false)
        
        guard let option = option as? StairsUtilityCoordinator.ViewState,
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
        
        guard let stairs = editor?.harvest.stairs,
              let tile = tile else { return }
        
        controller.gridRenderingButton.state = stairs.isHidden ? .off : .on
        controller.nodeCountLabel.integerValue = stairs.chunks.count
                 
        controller.nodeBox.isHidden = false
        controller.buildBox.isHidden = true
        
        controller.nodeRenderingButton.state = tile.isHidden ? .off : .on
        controller.nodeCoordinateView.coordinate = tile.coordinate
        controller.inspectorTypePopUp.selectItem(at: tile.tileType.rawValue)
        controller.inspectorMaterialPopUp.selectItem(at: tile.material.rawValue)
        controller.inspectorDirectionPopUp.selectItem(at: tile.footprint.rotation.rawValue)
    }
}

extension StairsInspectorCoordinator {
    
    func stateDidChange(from previousState: SpriteView.MouseState?, to currentState: SpriteView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self,
                  let spriteView = self.spriteView,
                  let map = spriteView.scene as? Scene2D else { return }
            
            switch currentState {
            
            case .up(let position, _):
                
                let hit = map.hitTest(point: position.end)
                
                guard let node = map.harvest.stairs.find(chunk: hit) else { return }
                
                self.toggle(inspector: .stairs, with: StairsUtilityCoordinator.ViewState.inspector(node: node))
                
            default: break
            }
        }
    }
}
