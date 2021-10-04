//
//  TreeToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Meadow
import SwiftUI

struct TreeToolModel {
    
    let tool: Tool
    
    @State var rendering: Bool
    
    @State var species: TreeSpecies = .spruce
    @State var direction: Cardinal = .north
}
