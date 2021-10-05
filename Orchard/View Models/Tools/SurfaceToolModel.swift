//
//  SurfaceToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Meadow
import SwiftUI

class SurfaceToolModel: ObservableObject {
    
    @Published var rendering: Bool = true
    
    @Published var material: SurfaceMaterial = .dirt
    @Published var overlay: SurfaceOverlay? = nil
    @Published var elevation: Int = World.Constants.ceiling / 2
    @Published var tileType: SurfaceTileType = .sloped
}
