//
//  ToolViewModel.swift
//
//  Created by Zack Brown on 05/10/2021.
//

import Foundation
import SwiftUI

class ToolViewModel: ObservableObject {
    
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
