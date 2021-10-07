//
//  PortalToolModel.swift
//
//  Created by Zack Brown on 04/10/2021.
//

import Harvest
import Meadow
import SwiftUI

class PortalToolModel: GridBuilder, ObservableObject {
    
    @Published var rendering: Bool = true
    
    @Published var portalType: PortalType = .portal
    @Published var identifier: String = ""
    
    @Published var segue = Segue()
}

extension PortalToolModel {
    
    func build(harvest: Map2D, event: Scene2D.CursorObserver.CursorEvent) {
        
        //
    }
}
