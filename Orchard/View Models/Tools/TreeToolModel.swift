//
//  TreeToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Harvest
import Meadow
import PeakOperation
import SwiftUI

class TreeToolModel: GridBuilder, ObservableObject {
    
    @Published var rendering: Bool = true
    
    @Published var species: TreeSpecies = .spruce
    @Published var direction: Cardinal = .north
}

extension TreeToolModel {
    
    func operation(for event: Scene2D.CursorObserver.CursorEvent, in scene: Scene2D) -> ConcurrentOperation? {
     
        switch event.eventType {
            
        case .left:
            
            let prop = Prop.foliage(foliageType: .tree(species: species))
            
            return PropBuilderOperation(event: event, scene: scene, prop: prop, rotation: direction)
            
        default: return GridRemovalOperation(event: event, scene: scene, tool: .trees)
        }
    }
}
