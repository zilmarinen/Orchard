//
//  ToolViewModel.swift
//
//  Created by Zack Brown on 05/10/2021.
//

import Foundation
import Harvest
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
    
    func build(harvest: Map2D, event: Scene2D.CursorObserver.CursorEvent) {
        
        print("Building: \(event.position.start) -> \(event.position.end)")
        switch tool {
            
        case .bridges: bridgeModel.build(harvest: harvest, event: event)
        case .bushes: bushModel.build(harvest: harvest, event: event)
        case .buildings: buildingModel.build(harvest: harvest, event: event)
        case .footpaths: footpathModel.build(harvest: harvest, event: event)
        case .portals: portalModel.build(harvest: harvest, event: event)
        case .rocks: rockModel.build(harvest: harvest, event: event)
        case .seams: seamModel.build(harvest: harvest, event: event)
        case .stairs: stairModel.build(harvest: harvest, event: event)
        case .surface: surfaceModel.build(harvest: harvest, event: event)
        case .trees: treeModel.build(harvest: harvest, event: event)
        case .walls: wallModel.build(harvest: harvest, event: event)
        case .water: waterModel.build(harvest: harvest, event: event)
        default: break
        }
    }
}
