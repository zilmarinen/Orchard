//
//  SurfaceElevationCoordinator.swift
//
//  Created by Zack Brown on 12/03/2021.
//

import Cocoa
import Harvest
import Meadow

class SurfaceElevationCoordinator: SurfaceCoordinator, MouseObservable {
    
    var mouseObserver: UUID?
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        subscribeToMouseEvents(tracksIdleEvents: true)
        
        editor?.map.surface.overlay = .elevation
        
        guard controller.isViewLoaded else { return }
        
        refresh()
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        unsubscribeFromMouseEvents()
        
        editor?.map.surface.overlay = .material
        
        super.stop(then: completion)
    }
    
    override func refresh() {
        
        guard let surface = editor?.map.surface else { return }
        
        controller.gridRenderingButton.state = surface.isHidden ? .off : .on
        controller.chunkCountLabel.integerValue = surface.chunks.count
                 
        controller.tileBox.isHidden = true
        controller.materialBox.isHidden = true
        controller.elevationBox.isHidden = false
        controller.edgeBox.isHidden = true
    }
}

extension SurfaceElevationCoordinator {
    
    func stateDidChange(from previousState: SpriteView.MouseState?, to currentState: SpriteView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self,
                  let spriteView = self.spriteView,
                  let scene = spriteView.scene as? Scene2D else { return }
            
            switch currentState {
            
            case .up(let position, _):
                
                let startHit = scene.hitTest(point: position.start)
                let endHit = scene.hitTest(point: position.end)
                
                let bounds = GridBounds(start: startHit, end: endHit)
                
                bounds.enumerate(y: 0) { coordinate in
                    
                    guard let tile = scene.map.surface.find(tile: coordinate) else { return }
                    
                    tile.coordinate = Coordinate(x: coordinate.x, y: self.controller.elevationLayerStepper.integerValue, z: coordinate.z)
                    
                    if let footpathTile = scene.map.footpath.find(tile: coordinate) {
                        
                        footpathTile.coordinate = coordinate
                    }
                    
                    //TODO: update foliage elevation
                }
                
            default: break
            }
            
            self.refresh()
        }
    }
}
