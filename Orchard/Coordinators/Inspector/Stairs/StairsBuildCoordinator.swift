//
//  StairsBuildCoordinator.swift
//
//  Created by Zack Brown on 30/03/2021.
//

import Cocoa
import Harvest
import Meadow

class StairsBuildCoordinator: StairsCoordinator, MouseObservable {
    
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
        
        guard let stairs = editor?.harvest.stairs else { return }
        
        controller.gridRenderingButton.state = stairs.isHidden ? .off : .on
        controller.nodeCountLabel.integerValue = stairs.chunks.count
                 
        controller.nodeBox.isHidden = true
        controller.buildBox.isHidden = false
    }
}

extension StairsBuildCoordinator {
    
    func stateDidChange(from previousState: SpriteView.MouseState?, to currentState: SpriteView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self,
                  let spriteView = self.spriteView,
                  let map = spriteView.scene as? Scene2D,
                  let direction = Cardinal(rawValue: self.controller.buildDirectionPopUp.indexOfSelectedItem) else { return }
            
            switch currentState {
            
            case .up(let position, let clickType):
                
                let startHit = map.hitTest(point: position.start)
                let endHit = map.hitTest(point: position.end)
                
                switch clickType {
                
                case .right:
                    
                    let bounds = GridBounds(start: startHit, end: endHit)
                    
                    bounds.enumerate(y: 0) { coordinate in
                     
                        map.harvest.stairs.remove(chunk: coordinate)
                    }
                    
                default:
                    
                    guard let startSurfaceTile = map.harvest.surface.find(tile: startHit),
                          let endSurfaceTile = map.harvest.surface.find(tile: endHit),
                          startSurfaceTile.coordinate.y == endSurfaceTile.coordinate.y else { return }
                    
                    let bounds = GridBounds(start: startSurfaceTile.coordinate, end: endSurfaceTile.coordinate)
                    
                    let elevation = self.controller.elevationStepper.integerValue
                    
                    _ = map.harvest.stairs.add(stairs: bounds) { stairs in
                        
                        stairs.direction = direction
                        stairs.elevation = elevation
                    }
                }
                
            default: break
            }
            
            self.refresh()
        }
    }
}

