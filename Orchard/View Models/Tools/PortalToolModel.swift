//
//  PortalToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Meadow
import SwiftUI

class PortalToolModel: ObservableObject {
    
    @Published var rendering: Bool = true
    
    @Published var portalType: PortalType = .portal
    @Published var identifier: String = ""
    
    @Published var segue = Segue()
}
