//
//  StairToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Meadow
import SwiftUI

struct StairToolModel {
    
    let tool: Tool
    
    @State var rendering: Bool
    
    @State var material: StairMaterial = .stone
    @State var stairType: StairType = .sloped_1x1
    @State var direction: Cardinal = .north
}
