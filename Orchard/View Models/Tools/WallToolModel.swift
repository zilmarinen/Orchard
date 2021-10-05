//
//  WallToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Meadow
import SwiftUI

class WallToolModel: ObservableObject {
    
    @Published var rendering: Bool = true
    
    @Published var wallType: WallType = .wall
    @Published var material: WallMaterial = .concrete
}
