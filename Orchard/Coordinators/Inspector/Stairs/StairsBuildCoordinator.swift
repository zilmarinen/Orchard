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
        
        guard let stairs = editor?.map.stairs else { return }
        
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
                  let scene = spriteView.scene as? Scene2D,
                  let rotation = Cardinal(rawValue: self.controller.buildDirectionPopUp.indexOfSelectedItem),
                  let tileType = StairType(rawValue: self.controller.buildTypePopUp.indexOfSelectedItem),
                  let material = StairMaterial(rawValue: self.controller.buildMaterialPopUp.indexOfSelectedItem) else { return }
            
            switch currentState {
            
            case .up(let position, let clickType):
                
                let startHit = scene.hitTest(point: position.start)
                let endHit = scene.hitTest(point: position.end)
                
                switch clickType {
                
                case .right:
                    
                    let bounds = GridBounds(start: startHit, end: endHit)
                    
                    bounds.enumerate(y: 0) { coordinate in
                     
                        scene.map.stairs.remove(chunk: coordinate)
                    }
                    
                default:
                    
                    guard let surfaceTile = scene.map.surface.find(tile: startHit) else { return }
                    
                    _ = scene.map.stairs.add(stairs: surfaceTile.coordinate, rotation: rotation, tileType: tileType, material: material)
                }
                
            default: break
            }
            
            self.refresh()
        }
    }
}

