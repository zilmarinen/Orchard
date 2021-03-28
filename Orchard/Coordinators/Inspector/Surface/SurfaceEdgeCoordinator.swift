//
//  SurfaceEdgeCoordinator.swift
//
//  Created by Zack Brown on 21/03/2021.
//

import Cocoa
import Meadow

class SurfaceEdgeCoordinator: SurfaceCoordinator, MouseObservable {
    
    var mouseObserver: UUID?
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        subscribeToMouseEvents(tracksIdleEvents: true)
        
        editor?.surface.overlay = .edge
        
        guard controller.isViewLoaded else { return }
        
        refresh()
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        unsubscribeFromMouseEvents()
        
        editor?.surface.overlay = .material
        
        super.stop(then: completion)
    }
    
    override func refresh() {
        
        guard let surface = editor?.surface else { return }
        
        controller.gridRenderingButton.state = surface.isHidden ? .off : .on
        controller.chunkCountLabel.integerValue = surface.chunks.count
                 
        controller.tileBox.isHidden = true
        controller.materialBox.isHidden = true
        controller.elevationBox.isHidden = true
        controller.edgeBox.isHidden = false
    }
}

extension SurfaceEdgeCoordinator {
    
    func stateDidChange(from previousState: SpriteView.MouseState?, to currentState: SpriteView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self,
                  let spriteView = self.spriteView,
                  let map = spriteView.scene as? Map,
                  let edgeType = SurfaceEdgeType(rawValue: self.controller.edgeTypePopUp.indexOfSelectedItem) else { return }
            
            switch currentState {
            
            case .up(let position, _):
                
                let startHit = map.hitTest(point: position.start)
                let endHit = map.hitTest(point: position.end)
                
                let bounds = GridBounds(start: startHit, end: endHit)
                
                bounds.enumerate(y: 0) { coordinate in
                    
                    guard let tile = map.meadow.surface.find(tile: coordinate) else { return }
                    
                    tile.edgeType = edgeType
                }
                
            default: break
            }
            
            self.refresh()
        }
    }
}
