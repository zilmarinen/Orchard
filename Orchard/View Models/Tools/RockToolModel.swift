//
//  RockToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Meadow
import SwiftUI

struct RockToolModel {
    
    let tool: Tool
    
    @State var rendering: Bool
    
    @State var rockType: RockType = .causeway
    @State var direction: Cardinal = .north
}
