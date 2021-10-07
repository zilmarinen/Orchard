//
//  WaterToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Harvest
import Meadow
import SwiftUI

class WaterToolModel: GridBuilder, ObservableObject {
    
    @Published var rendering: Bool = true
    
    @Published var material: WaterMaterial = .water
    
    @Published var elevation: Int = 0
}

extension WaterToolModel {
    
    func build(harvest: Map2D, event: Scene2D.CursorObserver.CursorEvent) {
        
        //
    }
}
