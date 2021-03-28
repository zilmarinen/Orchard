//
//  WaterMaterialCoordinator.swift
//
//  Created by Zack Brown on 21/03/2021.
//

import Cocoa
import Meadow

class WaterMaterialCoordinator: WaterCoordinator, MouseObservable {
    
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
        
        guard let water = editor?.water else { return }
        
        controller.gridRenderingButton.state = water.isHidden ? .off : .on
        controller.chunkCountLabel.integerValue = water.chunks.count
                 
        controller.tileBox.isHidden = true
        controller.materialBox.isHidden = false
    }
}

extension WaterMaterialCoordinator {
    
    func stateDidChange(from previousState: SpriteView.MouseState?, to currentState: SpriteView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self,
                  let spriteView = self.spriteView,
                  let map = spriteView.scene as? Map,
                  let tileType = WaterTileType(rawValue: self.controller.materialTypePopUp.indexOfSelectedItem) else { return }
            
            switch currentState {
            
            case .up(let position, let clickType):
                
                let startHit = map.hitTest(point: position.start)
                let endHit = map.hitTest(point: position.end)
                
                let bounds = GridBounds(start: startHit, end: endHit)
                
                bounds.enumerate(y: self.controller.materialLayerStepper.integerValue) { coordinate in
                    
                    switch clickType {
                    
                    case .right:
                        
                        map.meadow.water.remove(tile: coordinate)
                        
                    default:
                        
                        let tile = map.meadow.water.find(tile: coordinate) ?? map.meadow.water.add(tile: coordinate)
                        
                        tile?.coordinate = coordinate
                        tile?.tileType = tileType
                    }
                }
                
            default: break
            }
            
            self.refresh()
        }
    }
}
