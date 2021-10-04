//
//  SurfaceToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Meadow
import SwiftUI

struct SurfaceToolModel {
    
    let tool: Tool
    
    @State var rendering: Bool
    
    @State var material: SurfaceMaterial = .dirt
    @State var overlay: SurfaceOverlay?
    @State var elevation: Int = World.Constants.ceiling / 2
    @State var tileType: SurfaceTileType = .sloped
}
