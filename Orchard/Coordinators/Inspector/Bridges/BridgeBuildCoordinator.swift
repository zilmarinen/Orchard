//
//  BridgeBuildCoordinator.swift
//
//  Created by Zack Brown on 30/03/2021.
//

import Cocoa
import Harvest
import Meadow

class BridgeBuildCoordinator: BridgeCoordinator, MouseObservable {
    
    var mouseObserver: UUID?
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        subscribeToMouseEvents(tracksIdleEvents: true)
        
        editor?.map.surface.overlay = .none
        editor?.map.bridges.overlay = .pattern
        
        guard controller.isViewLoaded else { return }
        
        refresh()
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        unsubscribeFromMouseEvents()
        
        editor?.map.surface.overlay = .elevation
        editor?.map.bridges.overlay = .none
        
        super.stop(then: completion)
    }
    
    override func refresh() {
        
        guard let bridges = editor?.map.bridges else { return }
        
        controller.gridRenderingButton.state = bridges.isHidden ? .off : .on
        controller.chunkCountLabel.integerValue = bridges.chunks.count
                 
        controller.tileBox.isHidden = true
        controller.buildBox.isHidden = false
    }
}

extension BridgeBuildCoordinator {
    
    func stateDidChange(from previousState: SpriteView.MouseState?, to currentState: SpriteView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self,
                  let spriteView = self.spriteView,
                  let scene = spriteView.scene as? Scene2D,
                  let material = BridgeMaterial(rawValue: self.controller.buildMaterialPopUp.indexOfSelectedItem) else { return }
            
            switch currentState {
            
            case .up(let position, let clickType):
                
                let startHit = scene.hitTest(point: position.start)
                let endHit = scene.hitTest(point: position.end)
                
                guard let surfaceTile = scene.map.surface.find(tile: startHit) else { return }
                
                let bounds = GridBounds(start: startHit, end: endHit)
                
                bounds.enumerate(y: surfaceTile.coordinate.y) { coordinate in
                 
                    switch clickType {
                    
                    case .right:
                        
                        scene.map.bridges.remove(tile: coordinate)
                        
                    default:
                        
                        _ = scene.map.bridges.add(tile: coordinate) { bridge in
                            
                            bridge.material = material
                        }
                    }
                }
                
            default: break
            }
            
            self.refresh()
        }
    }
}
