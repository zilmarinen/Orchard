//
//  FoliagePlantCoordinator.swift
//
//  Created by Zack Brown on 15/03/2021.
//

import Cocoa
import Meadow

class FoliagePlantCoordinator: FoliageCoordinator, MouseObservable {
    
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
        
        guard let foliage = editor?.foliage else { return }
        
        controller.gridRenderingButton.state = foliage.isHidden ? .off : .on
        controller.nodeCountLabel.integerValue = foliage.chunks.count
                 
        controller.nodeBox.isHidden = true
        controller.plantBox.isHidden = false
    }
}

extension FoliagePlantCoordinator {
    
    func stateDidChange(from previousState: SpriteView.MouseState?, to currentState: SpriteView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self,
                  let spriteView = self.spriteView,
                  let map = spriteView.scene as? Map,
                  let foliageType = FoliageType(rawValue: self.controller.plantTypePopUp.indexOfSelectedItem),
                  let foliageSize = FoliageSize(rawValue: self.controller.plantSizePopUp.indexOfSelectedItem) else { return }
            
            switch currentState {
            
            case .up(let position, let clickType):
                
                let startHit = map.hitTest(point: position.start)
                let endHit = map.hitTest(point: position.end)
                
                switch clickType {
                
                case .right:
                    
                    let bounds = GridBounds(start: startHit, end: endHit)
                    
                    bounds.enumerate(y: 0) { coordinate in
                     
                        map.meadow.foliage.remove(chunk: coordinate)
                    }
                    
                default:
                    
                    guard let surfaceTile = map.meadow.surface.find(tile: endHit) else { return }
                    
                    let footprint = Footprint(coordinate: surfaceTile.coordinate, rotation: .north, size: foliageSize.rawValue + 1)
                    
                    guard map.meadow.foliage.find(chunk: footprint) == nil,
                          map.meadow.buildings.find(chunk: footprint) == nil,
                          map.meadow.portals.find(chunk: footprint) == nil else { return }
                    
                    _ = map.meadow.foliage.add(chunk: footprint) { chunk in
                        
                        chunk.foliageType = foliageType
                        chunk.foliageSize = foliageSize
                    }
                }
                
            default: break
            }
            
            self.refresh()
        }
    }
}

