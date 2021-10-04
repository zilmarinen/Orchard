//
//  FootpathToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Meadow
import SwiftUI

struct FootpathToolModel {
    
    let tool: Tool
    
    @State var rendering: Bool
    
    @State var material: FootpathMaterial = .dirt
}
