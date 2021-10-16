//
//  SeamBuilderOperation.swift
//
//  Created by Zack Brown on 11/10/2021.
//

import Foundation
import Harvest
import Meadow
import PeakOperation

class SeamBuilderOperation: ConcurrentOperation {
    
    let event: Scene2D.CursorObserver.CursorEvent
    let scene: Scene2D
    let model: SeamToolModel
    
    init(event: Scene2D.CursorObserver.CursorEvent, scene: Scene2D, model: SeamToolModel) {
        
        self.event = event
        self.scene = scene
        self.model = model
        
        super.init()
    }
    
    override func execute() {
        
        guard event.eventType == .left,
              let surface = scene.map.surface.find(tile: event.position.start) else { return finish() }
        
        _ = scene.map.seams.add(seam: surface.coordinate, configure: { [weak self] seam in
            
            guard let self = self else { return }
            
            seam.identifier = self.model.identifier
            seam.segue = PortalSegue(direction: self.model.segue.direction, map: self.model.segue.map, identifier: self.model.segue.identifier)
        })
        
        finish()
    }
}
