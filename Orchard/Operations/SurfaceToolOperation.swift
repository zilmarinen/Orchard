//
//  SurfaceToolOperation.swift
//
//  Created by Zack Brown on 08/10/2021.
//

import Foundation
import Harvest
import Meadow
import PeakOperation

class SurfaceToolOperation: ConcurrentOperation {
    
    let event: Scene2D.CursorObserver.CursorEvent
    let scene: Scene2D
    let model: SurfaceToolModel
    
    init(event: Scene2D.CursorObserver.CursorEvent, scene: Scene2D, model: SurfaceToolModel) {
        
        self.event = event
        self.scene = scene
        self.model = model
        
        super.init()
    }
    
    override func execute() {
        
        guard event.eventType == .left else { return finish() }
        
        event.position.enumerate(y: model.elevation) { coordinate in
            
            _ = scene.map.surface.add(tile: coordinate) { [weak self] tile in
                
                guard let self = self else { return }
                
                tile.coordinate = coordinate
                tile.material = self.model.material
                tile.overlay = self.model.overlay
                tile.tileType = self.model.tileType
            }
        }
        
        finish()
    }
}
