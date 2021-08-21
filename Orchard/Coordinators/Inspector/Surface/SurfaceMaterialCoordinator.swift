//
//  SurfaceMaterialCoordinator.swift
//
//  Created by Zack Brown on 11/03/2021.
//

import Cocoa
import Harvest
import Meadow

class SurfaceMaterialCoordinator: SurfaceCoordinator, MouseObservable {
    
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
        
        guard let surface = editor?.map.surface else { return }
        
        controller.gridRenderingButton.state = surface.isHidden ? .off : .on
        controller.chunkCountLabel.integerValue = surface.chunks.count
                 
        controller.tileBox.isHidden = true
        controller.materialBox.isHidden = false
        controller.elevationBox.isHidden = true
        controller.edgeBox.isHidden = true
    }
}

extension SurfaceMaterialCoordinator {
    
    func stateDidChange(from previousState: SpriteView.MouseState?, to currentState: SpriteView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self,
                  let spriteView = self.spriteView,
                  let scene = spriteView.scene as? Scene2D,
                  let tileType = SurfaceTileType(rawValue: self.controller.materialTypePopUp.indexOfSelectedItem),
                  let edgeType = SurfaceEdgeType(rawValue: self.controller.materialEdgeTypePopUp.indexOfSelectedItem) else { return }
            
            switch currentState {
            
            case .up(let position, let clickType):
                
                let startHit = scene.hitTest(point: position.start)
                let endHit = scene.hitTest(point: position.end)
                
                let bounds = GridBounds(start: startHit, end: endHit)
                
                bounds.enumerate(y: self.controller.materialLayerStepper.integerValue) { coordinate in
                    
                    switch clickType {
                    
                    case .right:
                        
                        scene.map.actors.remove(actor: coordinate)
                        scene.map.bridges.remove(tile: coordinate)
                        scene.map.buildings.remove(chunk: coordinate)
                        scene.map.foliage.remove(chunk: coordinate)
                        scene.map.footpath.remove(tile: coordinate)
                        scene.map.stairs.remove(chunk: coordinate)
                        scene.map.surface.remove(tile: coordinate)
                        scene.map.walls.remove(tile: coordinate)
                        scene.map.water.remove(tile: coordinate)
                        
                    default:
                        
                        guard let tile = scene.map.surface.add(tile: coordinate) else { break }
                        
                        tile.coordinate = coordinate
                        tile.tileType.primary = tileType
                        tile.edgeType = edgeType
                        
                        //TODO: adjust elevation of other grid tiles
                    }
                }
                
            default: break
            }
            
            self.refresh()
        }
    }
}
