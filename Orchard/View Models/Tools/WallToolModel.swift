//
//  WallToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Harvest
import Meadow
import SwiftUI

class WallToolModel: GridBuilder, ObservableObject {
    
    @Published var rendering: Bool = true
    
    @Published var wallType: WallType = .wall
    @Published var material: WallMaterial = .concrete
}

extension WallToolModel {
    
    func build(harvest: Map2D, event: Scene2D.CursorObserver.CursorEvent) {
        
        //
    }
}
