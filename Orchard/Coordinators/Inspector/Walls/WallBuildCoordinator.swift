//
//  WallBuildCoordinator.swift
//
//  Created by Zack Brown on 03/04/2021.
//

import Cocoa
import Harvest
import Meadow

class WallBuildCoordinator: WallCoordinator, MouseObservable {
    
    var mouseObserver: UUID?
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        subscribeToMouseEvents(tracksIdleEvents: true)
        
        editor?.harvest.surface.overlay = .none
        editor?.harvest.walls.overlay = .type
        
        guard controller.isViewLoaded else { return }
        
        refresh()
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        unsubscribeFromMouseEvents()
        
        editor?.harvest.surface.overlay = .elevation
        editor?.harvest.walls.overlay = .none
        
        super.stop(then: completion)
    }
    
    override func refresh() {
        
        guard let buildings = editor?.harvest.buildings else { return }
        
        controller.gridRenderingButton.state = buildings.isHidden ? .off : .on
        controller.nodeCountLabel.integerValue = buildings.chunks.count
                 
        controller.nodeBox.isHidden = true
        controller.buildBox.isHidden = false
    }
}

extension WallBuildCoordinator {
    
    func stateDidChange(from previousState: SpriteView.MouseState?, to currentState: SpriteView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self,
                  let spriteView = self.spriteView,
                  let map = spriteView.scene as? Scene2D,
                  let material = WallTileMaterial(rawValue: self.controller.buildMaterialPopUp.indexOfSelectedItem) else { return }
            
            switch currentState {
            
            case .up(let position, let clickType):
                
                let startHit = map.hitTest(point: position.start)
                let endHit = map.hitTest(point: position.end)
                
                let bounds = GridBounds(start: startHit, end: endHit)
                
                let tileType = WallTileType.allCases[self.controller.buildTypePopUp.indexOfSelectedItem]
                
                bounds.enumerate(y: 0) { coordinate in
                    
                    switch clickType {
                    
                    case .right:
                        
                        map.harvest.walls.remove(tile: coordinate)
                        
                    default:
                        
                        _ = map.harvest.walls.add(tile: coordinate) { wall in
                            
                            wall.tileType = tileType
                            wall.material = material
                        }
                    }
                }
                
            default: break
            }
            
            self.refresh()
        }
    }
}
