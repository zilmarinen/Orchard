//
//  FootpathMaterialCoordinator.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Cocoa
import Harvest
import Meadow

class FootpathMaterialCoordinator: FootpathCoordinator, MouseObservable {
    
    var mouseObserver: UUID?
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        subscribeToMouseEvents(tracksIdleEvents: true)
        
        editor?.map.surface.overlay = .none
        editor?.map.footpath.overlay = .pattern
        
        guard controller.isViewLoaded else { return }
        
        refresh()
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        unsubscribeFromMouseEvents()
        
        editor?.map.surface.overlay = .elevation
        editor?.map.footpath.overlay = .none
        
        super.stop(then: completion)
    }
    
    override func refresh() {
        
        guard let footpath = editor?.map.footpath else { return }
        
        controller.gridRenderingButton.state = footpath.isHidden ? .off : .on
        controller.chunkCountLabel.integerValue = footpath.chunks.count
                 
        controller.tileBox.isHidden = true
        controller.materialBox.isHidden = false
    }
}

extension FootpathMaterialCoordinator {
    
    func stateDidChange(from previousState: SpriteView.MouseState?, to currentState: SpriteView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self,
                  let spriteView = self.spriteView,
                  let scene = spriteView.scene as? Scene2D,
                  let tileType = FootpathTileType(rawValue: self.controller.materialTypePopUp.indexOfSelectedItem) else { return }
            
            switch currentState {
            
            case .up(let position, let clickType):
                
                let startHit = scene.hitTest(point: position.start)
                let endHit = scene.hitTest(point: position.end)
                
                let bounds = GridBounds(start: startHit, end: endHit)
                
                bounds.enumerate(y: 0) { coordinate in
                    
                    switch clickType {
                    
                    case .right:
                        
                        scene.map.footpath.remove(tile: coordinate)
                        
                    default:
                        
                        _ = scene.map.footpath.add(tile: coordinate) { tile in 
                        
                            tile.tileType = tileType
                        }
                    }
                }
                
            default: break
            }
            
            self.refresh()
        }
    }
}
