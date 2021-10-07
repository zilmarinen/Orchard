//
//  BuildingToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Harvest
import Meadow
import SwiftUI

class BuildingToolModel: GridBuilder, ObservableObject {
    
    @Published var rendering: Bool = true
    
    @Published var architecture: BuildingArchitecture = .bernina
    @Published var polyomino: Polyomino = .z
    @Published var direction: Cardinal = .north
}

extension BuildingToolModel {
    
    func build(harvest: Map2D, event: Scene2D.CursorObserver.CursorEvent) {
        
        switch event.eventType {
            
        case .left:
            
            guard let surface = harvest.surface.find(tile: event.position.start) else { return }
            
            let prop = Prop.building(architecture: architecture, polyomino: polyomino)
            
            _ = harvest.buildings.add(prop: prop, coordinate: surface.coordinate, rotation: direction) { [weak self] building in
                
                guard let self = self else { return }
                
                building.polyomino = self.polyomino
            }
            
            break
            
        default:
            
            event.position.enumerate(y: World.Constants.floor) { coordinate in
                
                harvest.buildings.remove(chunk: coordinate)
            }
        }
    }
}
