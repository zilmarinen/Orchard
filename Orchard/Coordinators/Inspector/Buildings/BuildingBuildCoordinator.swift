//
//  BuildingBuildCoordinator.swift
//
//  Created by Zack Brown on 15/03/2021.
//

import Cocoa
import Meadow

class BuildingBuildCoordinator: BuildingCoordinator, MouseObservable {
    
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
        
        guard let buildings = editor?.buildings else { return }
        
        controller.gridRenderingButton.state = buildings.isHidden ? .off : .on
        controller.nodeCountLabel.integerValue = buildings.chunks.count
                 
        controller.nodeBox.isHidden = true
        controller.buildBox.isHidden = false
    }
}

extension BuildingBuildCoordinator {
    
    func stateDidChange(from previousState: SpriteView.MouseState?, to currentState: SpriteView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self,
                  let spriteView = self.spriteView,
                  let map = spriteView.scene as? Map else { return }
            
            switch currentState {
            
            case .up(let position, let clickType):
                
                let startHit = map.hitTest(point: position.start)
                let endHit = map.hitTest(point: position.end)
                
                let bounds = GridBounds(start: startHit, end: endHit)
                
                bounds.enumerate(y: 0) { coordinate in
                    
                    switch clickType {
                    
                    case .right:
                        
                        map.meadow.buildings.remove(chunk: coordinate)
                        
                    default:
                        
                        guard let surfaceTile = map.meadow.surface.find(tile: endHit) else { return }
                        
                        let footprint = Footprint(coordinate: surfaceTile.coordinate, rotation: .north, size: 2)
                        
                        guard map.meadow.foliage.find(chunk: footprint) == nil,
                              map.meadow.buildings.find(chunk: footprint) == nil,
                              map.meadow.portals.find(chunk: footprint) == nil else { return }
                        
                        _ = map.meadow.buildings.add(chunk: footprint)
                    }
                }
                
            default: break
            }
            
            self.refresh()
        }
    }
}
