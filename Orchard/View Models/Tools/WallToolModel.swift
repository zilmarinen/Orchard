//
//  WallToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Meadow
import SwiftUI

struct WallToolModel {
    
    let tool: Tool
    
    @State var rendering: Bool
    
    @State var wallType: WallType = .wall
    @State var material: WallMaterial = .concrete
}
