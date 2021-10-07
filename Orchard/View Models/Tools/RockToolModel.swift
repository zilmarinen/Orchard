//
//  RockToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Harvest
import Meadow
import SwiftUI

class RockToolModel: GridBuilder, ObservableObject {
    
    @Published var rendering: Bool = true
    
    @Published var rockType: RockType = .causeway
    @Published var direction: Cardinal = .north
}

extension RockToolModel {
    
    func build(harvest: Map2D, event: Scene2D.CursorObserver.CursorEvent) {
        
        switch event.eventType {
            
        case .left:
            
            guard let surface = harvest.surface.find(tile: event.position.start) else { return }
            
            let prop = Prop.foliage(foliageType: .rock(rockType: rockType))
            
            _ = harvest.foliage.add(prop: prop, coordinate: surface.coordinate, rotation: direction)
            
            break
            
        default:
            
            event.position.enumerate(y: World.Constants.floor) { coordinate in
                
                harvest.foliage.remove(chunk: coordinate)
            }
        }
    }
}
