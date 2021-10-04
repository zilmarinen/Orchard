//
//  BridgeToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Meadow
import SwiftUI

struct BridgeToolModel {
    
    let tool: Tool
    
    @State var rendering: Bool
    
    @State var material: BridgeMaterial = .stone
}
