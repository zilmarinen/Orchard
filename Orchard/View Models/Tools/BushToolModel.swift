//
//  BushToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Meadow
import SwiftUI

struct BushToolModel {
    
    let tool: Tool
    
    @State var rendering: Bool
    
    @State var species: BushSpecies = .honeysuckle
    @State var direction: Cardinal = .north
}
