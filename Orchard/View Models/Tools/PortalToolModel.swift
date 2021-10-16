//
//  PortalToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Harvest
import Meadow
import PeakOperation
import SwiftUI

class PortalToolModel: GridBuilder, ObservableObject {
    
    @Published var rendering: Bool = true
    
    @Published var portalType: PortalType = .portal
    @Published var identifier: String = ""
    @Published var direction: Cardinal = .north
    
    @Published var segue = Segue()
}

extension PortalToolModel {
    
    func operation(for event: Scene2D.CursorObserver.CursorEvent, in scene: Scene2D) -> ConcurrentOperation? {
     
        switch event.eventType {
            
        case .left:
            
            let prop = Prop.portal(portalType: portalType)
            
            return PropBuilderOperation(event: event, scene: scene, prop: prop, rotation: direction)
            
        default: return GridRemovalOperation(event: event, scene: scene, tool: .portals)
        }
    }
}
