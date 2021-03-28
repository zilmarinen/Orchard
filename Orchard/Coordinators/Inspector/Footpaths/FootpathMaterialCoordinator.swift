//
//  FootpathMaterialCoordinator.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Cocoa
import Meadow

class FootpathMaterialCoordinator: FootpathCoordinator, MouseObservable {
    
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
        
        guard let footpath = editor?.footpath else { return }
        
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
                  let map = spriteView.scene as? Map,
                  let tileType = FootpathTileType(rawValue: self.controller.materialTypePopUp.indexOfSelectedItem) else { return }
            
            switch currentState {
            
            case .up(let position, let clickType):
                
                let startHit = map.hitTest(point: position.start)
                let endHit = map.hitTest(point: position.end)
                
                let bounds = GridBounds(start: startHit, end: endHit)
                
                bounds.enumerate(y: 0) { coordinate in
                    
                    switch clickType {
                    
                    case .right:
                        
                        map.meadow.footpath.remove(tile: coordinate)
                        
                    default:
                        
                        guard let surfaceTile = map.meadow.surface.find(tile: coordinate) else { break }
                            
                        let tile = map.meadow.footpath.find(tile: coordinate) ?? map.meadow.footpath.add(tile: coordinate)
                        
                        tile?.coordinate = surfaceTile.coordinate
                        tile?.tileType = tileType
                    }
                }
                
            default: break
            }
            
            self.refresh()
        }
    }
}
