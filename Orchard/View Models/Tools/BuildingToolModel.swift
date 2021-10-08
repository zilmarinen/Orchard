//
//  BuildingToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Harvest
import Meadow
import PeakOperation
import SwiftUI

class BuildingToolModel: GridBuilder, ObservableObject {
    
    @Published var rendering: Bool = true
    
    @Published var architecture: BuildingArchitecture = .bernina
    @Published var polyomino: Polyomino = .z
    @Published var direction: Cardinal = .north
}

extension BuildingToolModel {
    
    func operation(for event: Scene2D.CursorObserver.CursorEvent, in scene: Scene2D) -> ConcurrentOperation? {
     
        switch event.eventType {
            
        case .left:
            
            let prop = Prop.building(architecture: architecture, polyomino: polyomino)
            
            return PropBuilderOperation(event: event, scene: scene, prop: prop, rotation: direction)
            
        default: return GridRemovalOperation(event: event, scene: scene, tool: .buildings)
        }
    }
}
