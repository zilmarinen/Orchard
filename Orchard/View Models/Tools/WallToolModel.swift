//
//  WallToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Harvest
import Meadow
import PeakOperation
import SwiftUI

class WallToolModel: GridBuilder, ObservableObject {
    
    @Published var rendering: Bool = true
    
    @Published var wallType: WallType = .wall
    @Published var material: WallMaterial = .concrete
}

extension WallToolModel {
    
    func operation(for event: Scene2D.CursorObserver.CursorEvent, in scene: Scene2D) -> ConcurrentOperation? {
     
        switch event.eventType {
            
        case .left:
            
            let prop = Prop.wall(tileType: wallType, material: material, pattern: .north, external: false)
            
            return PropBuilderOperation(event: event, scene: scene, prop: prop, rotation: .north)
            
        default: return GridRemovalOperation(event: event, scene: scene, tool: .walls)
        }
    }
}
