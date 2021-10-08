//
//  BushToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Harvest
import Meadow
import PeakOperation
import SwiftUI

class BushToolModel: GridBuilder, ObservableObject {
    
    @Published var rendering: Bool = true
    
    @Published var species: BushSpecies = .honeysuckle
    @Published var direction: Cardinal = .north
}

extension BushToolModel {
    
    func operation(for event: Scene2D.CursorObserver.CursorEvent, in scene: Scene2D) -> ConcurrentOperation? {
     
        switch event.eventType {
            
        case .left:
            
            let prop = Prop.foliage(foliageType: .bush(species: species))
            
            return PropBuilderOperation(event: event, scene: scene, prop: prop, rotation: direction)
            
        default: return GridRemovalOperation(event: event, scene: scene, tool: .bushes)
        }
    }
}
