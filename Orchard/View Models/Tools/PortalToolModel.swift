//
//  PortalToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Meadow
import SwiftUI

struct PortalToolModel {
    
    let tool: Tool
    
    @State var rendering: Bool
    
    @State var portalType: PortalType = .portal
    @State var identifier: String = ""
    
    @State var segue = Segue(direction: .north, map: "", identifier: "")
}
