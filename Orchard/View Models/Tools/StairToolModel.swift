//
//  StairToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Harvest
import Meadow
import SwiftUI

class StairToolModel: GridBuilder, ObservableObject {
    
    @Published var rendering: Bool = true
    
    @Published var material: StairMaterial = .stone
    @Published var stairType: StairType = .sloped_1x1
    @Published var direction: Cardinal = .north
}

extension StairToolModel {
    
    func build(harvest: Map2D, event: Scene2D.CursorObserver.CursorEvent) {
        
        //
    }
}
