//
//  SeamToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Harvest
import Meadow
import SwiftUI

class SeamToolModel: GridBuilder, ObservableObject {
    
    @Published var rendering: Bool = true
    
    @Published var identifier: String = ""
    @Published var segue = Segue()
}

extension SeamToolModel {
    
    func build(harvest: Map2D, event: Scene2D.CursorObserver.CursorEvent) {
        
        switch event.eventType {
            
        case .left:
            
            guard let surface = harvest.surface.find(tile: event.position.start) else { return }
            
            _ = harvest.seams.add(seam: surface.coordinate) { [weak self] seam in
                
                guard let self = self else { return }
                
                seam.identifier = self.identifier
                seam.segue = PortalSegue(direction: self.segue.direction, map: self.segue.map, identifier: self.segue.identifier)
            }
            
            break
            
        default:
            
            event.position.enumerate(y: World.Constants.floor) { coordinate in
                
                harvest.buildings.remove(chunk: coordinate)
            }
        }
    }
}
