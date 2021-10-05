//
//  BridgeToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Harvest
import Meadow
import SwiftUI

class BridgeToolModel: ObservableObject {
    
    @Published var rendering: Bool = true
    
    @Published var material: BridgeMaterial = .stone
}
