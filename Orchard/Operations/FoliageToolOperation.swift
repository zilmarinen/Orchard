//
//  PropBuilderOperation.swift
//
//  Created by Zack Brown on 08/10/2021.
//

import Foundation
import Harvest
import Meadow
import PeakOperation

class PropBuilderOperation: ConcurrentOperation {
    
    let event: Scene2D.CursorObserver.CursorEvent
    let scene: Scene2D
    let prop: Prop
    let rotation: Cardinal
    
    init(event: Scene2D.CursorObserver.CursorEvent, scene: Scene2D, prop: Prop, rotation: Cardinal) {
        
        self.event = event
        self.scene = scene
        self.prop = prop
        self.rotation = rotation
        
        super.init()
    }
    
    override func execute() {
        
        guard event.eventType == .left,
              let surface = scene.map.surface.find(tile: event.position.start) else { return finish() }
        
        switch prop {
            
        case .bridge(let tileType, let material, _):
            
            event.position.enumerate(y: surface.coordinate.y) { coordinate in
                
                _ = scene.map.bridges.add(tile: coordinate) { bridge in
                    
                    bridge.tileType = tileType
                    bridge.material = material
                }
            }
            
        case .building(let architecture, let polyomino):
            
            _ = scene.map.buildings.add(prop: prop, coordinate: surface.coordinate, rotation: rotation) { building in
                
                building.architecture = architecture
                building.polyomino = polyomino
            }
            
        case .foliage(let foliageType):
            
            _ = scene.map.foliage.add(prop: prop, coordinate: surface.coordinate, rotation: rotation) { foliage in
                
                foliage.foliageType = foliageType
            }
            
        case .portal(let portalType):
            
            _ = scene.map.portals.add(prop: prop, coordinate: surface.coordinate, rotation: rotation, configure: { portal in
                
                portal.portalType = portalType
            })
            
        case .stairs(let stairType, let material):
            
            _ = scene.map.stairs.add(prop: prop, coordinate: surface.coordinate, rotation: rotation) { stairs in
                
                stairs.stairType = stairType
                stairs.material = material
            }
            
        case .wall(let tileType, let material, _, _):
            
            event.position.enumerate(y: surface.coordinate.y) { coordinate in
                
                _ = scene.map.walls.add(tile: coordinate) { wall in
                    
                    wall.tileType = tileType
                    wall.material = material
                }
            }
        }
        
        finish()
    }
}

