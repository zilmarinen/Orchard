//
//  BuildingBuildCoordinator.swift
//
//  Created by Zack Brown on 15/03/2021.
//

import Cocoa
import Harvest
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
        
        guard let buildings = editor?.harvest.buildings else { return }
        
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
                  let map = spriteView.scene as? Scene2D,
                  let buildingType = BuildingType(rawValue: self.controller.buildTypePopUp.indexOfSelectedItem) else { return }
            
            switch currentState {
            
            case .up(let position, let clickType):
                
                let startHit = map.hitTest(point: position.start)
                let endHit = map.hitTest(point: position.end)
                
                switch clickType {
                
                case .right:
                    
                    let bounds = GridBounds(start: startHit, end: endHit)
                    
                    bounds.enumerate(y: 0) { coordinate in
                     
                        map.harvest.buildings.remove(chunk: coordinate)
                    }
                    
                default:
                    
                    guard let surfaceTile = map.harvest.surface.find(tile: startHit) else { return }
                    
                    _ = map.harvest.buildings.add(building: surfaceTile.coordinate, rotation: .north, buildingType: buildingType)
                }
                
            default: break
            }
            
            self.refresh()
        }
    }
}
