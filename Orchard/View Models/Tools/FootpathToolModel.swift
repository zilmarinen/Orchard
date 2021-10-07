//
//  FootpathToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Harvest
import Meadow
import SwiftUI

class FootpathToolModel: GridBuilder, ObservableObject {
    
    @Published var rendering: Bool = true
    
    @Published var material: FootpathMaterial = .dirt
}

extension FootpathToolModel {
    
    func build(harvest: Map2D, event: Scene2D.CursorObserver.CursorEvent) {
        
        event.position.enumerate(y: World.Constants.floor) { coordinate in
            
            switch event.eventType {
                
            case .left:
                
                _ = harvest.footpath.add(tile: coordinate) { [weak self] tile in
                
                    guard let self = self else { return }
                    
                    tile.material = self.material
                }
                
            default: harvest.footpath.remove(tile: coordinate)
            }
        }
    }
}
