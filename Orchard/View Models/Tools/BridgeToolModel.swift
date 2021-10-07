//
//  BridgeToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Harvest
import Meadow
import SwiftUI

class BridgeToolModel: GridBuilder, ObservableObject {
    
    @Published var rendering: Bool = true
    
    @Published var material: BridgeMaterial = .stone
}

extension BridgeToolModel {
    
    func build(harvest: Map2D, event: Scene2D.CursorObserver.CursorEvent) {
        
        print("Event: \(event)")
    }
}
