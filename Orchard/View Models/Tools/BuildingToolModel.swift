//
//  BuildingToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Meadow
import SwiftUI

class BuildingToolModel: ObservableObject {
    
    @Published var rendering: Bool = true
    
    @Published var architecture: BuildingArchitecture = .bernina
    @Published var polyomino: Polyomino = .z
    @Published var direction: Cardinal = .north
}
