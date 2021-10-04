//
//  BuildingToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Meadow
import SwiftUI

struct BuildingToolModel {
    
    let tool: Tool
    
    @State var rendering: Bool
    
    @State var architecture: BuildingArchitecture = .bernina
    @State var polyomino: Polyomino = .z
    @State var direction: Cardinal = .north
}
