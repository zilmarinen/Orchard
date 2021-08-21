//
//  WaterMaterialCoordinator.swift
//
//  Created by Zack Brown on 21/03/2021.
//

import Cocoa
import Harvest
import Meadow

class WaterMaterialCoordinator: WaterCoordinator, MouseObservable {
    
    var mouseObserver: UUID?
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        subscribeToMouseEvents(tracksIdleEvents: true)
        
        editor?.map.water.overlay = .elevation
        
        guard controller.isViewLoaded else { return }
        
        refresh()
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        unsubscribeFromMouseEvents()
        
        editor?.map.water.overlay = .none
        
        super.stop(then: completion)
    }
    
    override func refresh() {
        
        guard let water = editor?.map.water else { return }
        
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
                  let scene = spriteView.scene as? Scene2D,
                  let tileType = WaterTileType(rawValue: self.controller.materialTypePopUp.indexOfSelectedItem) else { return }
            
            switch currentState {
            
            case .up(let position, let clickType):
                
                let startHit = scene.hitTest(point: position.start)
                let endHit = scene.hitTest(point: position.end)
                
                let bounds = GridBounds(start: startHit, end: endHit)
                
                bounds.enumerate(y: self.controller.materialLayerStepper.integerValue) { coordinate in
                    
                    switch clickType {
                    
                    case .right:
                        
                        scene.map.water.remove(tile: coordinate)
                        
                    default:
                        
                        _ = scene.map.water.add(tile: coordinate) { tile in
                        
                            tile.tileType = tileType
                            tile.coordinate = coordinate
                        }
                    }
                }
                
            default: break
            }
            
            self.refresh()
        }
    }
}
