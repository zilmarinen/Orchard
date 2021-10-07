//
//  SurfaceToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Harvest
import Meadow
import SwiftUI

class SurfaceToolModel: GridBuilder, ObservableObject {
    
    @Published var rendering: Bool = true
    
    @Published var material: SurfaceMaterial = .dirt
    @Published var overlay: SurfaceOverlay? = nil
    @Published var elevation: Int = World.Constants.ceiling / 2
    @Published var tileType: SurfaceTileType = .sloped
}

extension SurfaceToolModel {
    
    func build(harvest: Map2D, event: Scene2D.CursorObserver.CursorEvent) {
        
        event.position.enumerate(y: elevation) { coordinate in
            
            switch event.eventType {
                
            case .left:
                
                _ = harvest.surface.add(tile: coordinate) { [weak self] tile in
                
                    guard let self = self else { return }
                    
                    tile.material = self.material
                    tile.overlay = self.overlay
                    tile.tileType = self.tileType
                }
                
            default: harvest.surface.remove(tile: coordinate)
            }
        }
    }
}
