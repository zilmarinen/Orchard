//
//  SurfaceToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Harvest
import Meadow
import PeakOperation
import SwiftUI

class SurfaceToolModel: GridBuilder, ObservableObject {
    
    @Published var rendering: Bool = true
    
    @Published var material: SurfaceMaterial = .dirt
    @Published var overlay: SurfaceOverlay? = nil
    @Published var elevation: Int = World.Constants.ceiling / 2
    @Published var tileType: SurfaceTileType = .sloped
}

extension SurfaceToolModel {
    
    func operation(for event: Scene2D.CursorObserver.CursorEvent, in scene: Scene2D) -> ConcurrentOperation? {
     
        switch event.eventType {
            
        case .left: return SurfaceToolOperation(event: event, scene: scene, model: self)
        default: return GridRemovalOperation(event: event, scene: scene, tool: .surface)
        }
    }
}
