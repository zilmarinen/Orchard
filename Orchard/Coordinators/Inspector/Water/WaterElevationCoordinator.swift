//
//  WaterElevationCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 21/03/2021.
//

import Cocoa
import Meadow

class WaterElevationCoordinator: WaterCoordinator, MouseObservable {
    
    var mouseObserver: UUID?
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        subscribeToMouseEvents(tracksIdleEvents: true)
        
        editor?.water.showElevation = true
        
        guard controller.isViewLoaded else { return }
        
        refresh()
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        unsubscribeFromMouseEvents()
        
        editor?.water.showElevation = false
        
        super.stop(then: completion)
    }
    
    override func refresh() {
        
        guard let water = editor?.water else { return }
        
        controller.gridRenderingButton.state = water.isHidden ? .off : .on
        controller.chunkCountLabel.integerValue = water.chunks.count
                 
        controller.tileBox.isHidden = true
        controller.materialBox.isHidden = true
        controller.elevationBox.isHidden = false
    }
}

extension WaterElevationCoordinator {
    
    func stateDidChange(from previousState: SpriteView.MouseState?, to currentState: SpriteView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self,
                  let spriteView = self.spriteView,
                  let map = spriteView.scene as? Map else { return }
            
            switch currentState {
            
            case .up(let position, _):
                
                let startHit = map.hitTest(point: position.start)
                let endHit = map.hitTest(point: position.end)
                
                let bounds = GridBounds(start: startHit, end: endHit)
                
                bounds.enumerate(y: 0) { coordinate in
                    
                    guard let tile = map.meadow.water.find(tile: coordinate),
                          let surfaceTile = map.meadow.surface.find(tile: coordinate) else { return }
                    
                    let y = max(self.controller.elevationLayerStepper.integerValue, surfaceTile.coordinate.y + 1)
                    
                    tile.coordinate = Coordinate(x: coordinate.x, y: y, z: coordinate.z)
                }
                
            default: break
            }
            
            self.refresh()
        }
    }
}
