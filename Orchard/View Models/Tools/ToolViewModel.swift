//
//  ToolViewModel.swift
//
//  Created by Zack Brown on 05/10/2021.
//

import Foundation
import Harvest
import PeakOperation
import SwiftUI

class ToolViewModel: GridBuilder, ObservableObject {
    
    @Published var tool: Tool? = .surface
    
    @Published var bridgeModel = BridgeToolModel()
    @Published var buildingModel = BuildingToolModel()
    @Published var bushModel = BushToolModel()
    @Published var footpathModel = FootpathToolModel()
    @Published var mapModel = MapToolModel()
    @Published var portalModel = PortalToolModel()
    @Published var rockModel = RockToolModel()
    @Published var seamModel = SeamToolModel()
    @Published var stairModel = StairToolModel()
    @Published var surfaceModel = SurfaceToolModel()
    @Published var treeModel = TreeToolModel()
    @Published var wallModel = WallToolModel()
    @Published var waterModel = WaterToolModel()
}

extension ToolViewModel {
    
    func operation(for event: Scene2D.CursorObserver.CursorEvent, in scene: Scene2D) -> ConcurrentOperation? {
        
        switch tool {
            
        case .bridges: return bridgeModel.operation(for: event, in: scene)
        case .bushes: return bushModel.operation(for: event, in: scene)
        case .buildings: return buildingModel.operation(for: event, in: scene)
        case .footpaths: return footpathModel.operation(for: event, in: scene)
        case .portals: return portalModel.operation(for: event, in: scene)
        case .rocks: return rockModel.operation(for: event, in: scene)
        case .seams: return seamModel.operation(for: event, in: scene)
        case .stairs: return stairModel.operation(for: event, in: scene)
        case .surface: return surfaceModel.operation(for: event, in: scene)
        case .trees: return treeModel.operation(for: event, in: scene)
        case .walls: return wallModel.operation(for: event, in: scene)
        case .water: return waterModel.operation(for: event, in: scene)
        default: return nil
        }
    }
}
