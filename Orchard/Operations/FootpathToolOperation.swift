//
//  FootpathToolOperation.swift
//
//  Created by Zack Brown on 08/10/2021.
//

import Foundation
import Harvest
import Meadow
import PeakOperation

class FootpathToolOperation: ConcurrentOperation {
    
    let event: Scene2D.CursorObserver.CursorEvent
    let scene: Scene2D
    let model: FootpathToolModel
    
    init(event: Scene2D.CursorObserver.CursorEvent, scene: Scene2D, model: FootpathToolModel) {
        
        self.event = event
        self.scene = scene
        self.model = model
        
        super.init()
    }
    
    override func execute() {
        
        guard event.eventType == .left else { return finish() }
        
        event.position.enumerate(y: 0) { coordinate in
            
            _ = scene.map.footpath.add(tile: coordinate) { [weak self] tile in
                
                guard let self = self else { return }
                
                tile.material = self.model.material
            }
        }
        
        finish()
    }
}
