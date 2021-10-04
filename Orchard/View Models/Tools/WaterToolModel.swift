//
//  WaterToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Meadow
import SwiftUI

struct WaterToolModel {
    
    let tool: Tool
    
    @State var rendering: Bool
    
    @State var material: WaterMaterial = .water
    
    @State var elevation: Int = World.Constants.ceiling / 2
}
