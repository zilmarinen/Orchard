//
//  GridRemovalOperation.swift
//
//  Created by Zack Brown on 08/10/2021.
//

import Foundation
import Harvest
import Meadow
import PeakOperation

class GridRemovalOperation: ConcurrentOperation {
    
    let event: Scene2D.CursorObserver.CursorEvent
    let scene: Scene2D
    let tool: Tool
    
    init(event: Scene2D.CursorObserver.CursorEvent, scene: Scene2D, tool: Tool) {
        
        self.event = event
        self.scene = scene
        self.tool = tool
        
        super.init()
    }
    
    override func execute() {
        
        guard event.eventType == .right else { return finish() }
        
        event.position.enumerate(y: World.Constants.floor) { coordinate in
         
            switch tool {
                
            case .bridges: scene.map.bridges.remove(tile: coordinate)
            case .buildings: scene.map.buildings.remove(chunk: coordinate)
            case .footpaths: scene.map.footpath.remove(tile: coordinate)
            case .portals: scene.map.portals.remove(chunk: coordinate)
            case .seams: scene.map.seams.remove(tile: coordinate)
            case .stairs: scene.map.stairs.remove(chunk: coordinate)
            case .surface: scene.map.surface.remove(tile: coordinate)
            case .walls: scene.map.walls.remove(tile: coordinate)
            case .water: scene.map.water.remove(tile: coordinate)
            default: scene.map.foliage.remove(chunk: coordinate)
            }
        }
        
        finish()
    }
}
