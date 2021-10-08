//
//  BridgeToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Harvest
import Meadow
import PeakOperation
import SwiftUI

class BridgeToolModel: GridBuilder, ObservableObject {
    
    @Published var rendering: Bool = true
    
    @Published var material: BridgeMaterial = .stone
}

extension BridgeToolModel {
    
    func operation(for event: Scene2D.CursorObserver.CursorEvent, in scene: Scene2D) -> ConcurrentOperation? {
     
        switch event.eventType {
            
        case .left:
            
            let prop = Prop.bridge(tileType: .wall, material: material, pattern: .north)
            
            return PropBuilderOperation(event: event, scene: scene, prop: prop, rotation: .north)
            
        default: return GridRemovalOperation(event: event, scene: scene, tool: .bridges)
        }
    }
}
