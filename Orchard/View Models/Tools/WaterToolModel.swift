//
//  WaterToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Harvest
import Meadow
import PeakOperation
import SwiftUI

class WaterToolModel: GridBuilder, ObservableObject {
    
    @Published var rendering: Bool = true
    
    @Published var material: WaterMaterial = .water
    
    @Published var elevation: Int = 0
}

extension WaterToolModel {
    
    func operation(for event: Scene2D.CursorObserver.CursorEvent, in scene: Scene2D) -> ConcurrentOperation? {
     
        switch event.eventType {
            
        case .left: return WaterToolOperation(event: event, scene: scene, model: self)
        default: return GridRemovalOperation(event: event, scene: scene, tool: .water)
        }
    }
}
